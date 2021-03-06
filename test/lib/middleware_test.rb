require 'test_helper'
require 'pry'

class MiddlawareTest < Minitest::Test
  def setup
    redis = MockRedis.new
    client = Object.new

    redis.stubs(:client).returns(client)
    client.stubs(:location).returns('MockRedis')

    Sidekiq::RedisConnection.stubs(:create).returns(ConnectionPool.new({}) { redis })
  end

  def test_job_in_interval
    t = Time.utc(2008, 9, 1, 1, 0, 0)
    Timecop.travel(t)

    assert { SomeJob.jobs.size == 0 }
    SomeJob.perform_async
    assert { SomeJob.jobs.size == 1 }
    SomeJob.drain
    assert { SomeJob.jobs.size == 0 }

    Timecop.return
  end

  def test_job_not_in_interval
    t = Time.utc(2008, 9, 1, 1, 0, 0)
    Timecop.travel(t)

    assert { SomeIvarJob.jobs.size == 0 }
    SomeIvarJob.perform_async
    assert { SomeIvarJob.jobs.size == 1 }
    jobs = []
    while job = SomeIvarJob.jobs.shift do
      jobs << job
    end
    while job = jobs.shift do
     SomeIvarJob.process_job(job)
    end
    ej = 0
    Sidekiq.redis do |conn|
      ej += conn.zrange("default", 0, -1).size
    end
    assert { ej == 1 }

    Timecop.return
  end

  def test_job_without_interval_settings
    t = Time.utc(2008, 9, 1, 1, 0, 0)
    Timecop.travel(t)

    assert { SomeSimpleJob.jobs.size == 0 }
    SomeSimpleJob.perform_async
    assert { SomeSimpleJob.jobs.size == 1 }
    SomeSimpleJob.drain
    assert { SomeSimpleJob.jobs.size == 0 }

    Timecop.return
  end
end
