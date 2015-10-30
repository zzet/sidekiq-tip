require 'simplecov'
SimpleCov.start

require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/autorun'
require 'timecop'
require 'wrong'
require 'mocha/setup'
require 'mock_redis'

require 'sidekiq'
require 'celluloid/current'
require 'celluloid/test'
Celluloid.boot

require 'sidekiq/cli'
require 'sidekiq/processor'
require 'sidekiq/util'

require 'sidekiq/tip'
require 'sidekiq/testing'

Sidekiq::Testing.server_middleware do |chain|
  chain.add Sidekiq::Tip::Server::Middleware
end

Wrong.config.color

require 'sidekiq/redis_connection'
REDIS_URL = ENV['REDIS_URL'] || 'redis://localhost/15'
REDIS = Sidekiq::RedisConnection.create(:url => REDIS_URL, :namespace => 'testy')

Sidekiq.configure_client do |config|
  config.redis = { :url => REDIS_URL, :namespace => 'testy' }
end

class MiniTest::Test
  include Wrong
end


class SomeJob
  include Sidekiq::Worker

  sidekiq_options start_at: [0, 0, 0], finish_at: [10, 0, 0]

  def perform; end
end

class SomeIvarJob
  include Sidekiq::Worker

  sidekiq_options start_at: [10, 0, 0], finish_at: [15, 0, 0]

  def perform; end
end

class SomeSimpleJob
  include Sidekiq::Worker

  def perform; end
end
