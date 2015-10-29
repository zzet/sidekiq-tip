require 'pry'
module Sidekiq
  module Tip
    module Server
      class Middleware
        def initialize(options={})
          @start_at  = options.fetch(:start_at,  [0, 0, 0]) # hour, minutes, second
          @finish_at = options.fetch(:finish_at, [23, 59, 59]) # hour, minutes, second
        end

        def call(worker, msg, queue)
          fetch_times(msg)

          if appropriate_time_interval?
            yield
          else
            payload = Sidekiq.dump_json(msg)

            Sidekiq.redis do |conn|
              conn.zadd(queue, next_start_time.to_s, payload)
            end
          end
        end

        #private

        def fetch_times(msg)
          @start_at = msg.fetch('start_at', @start_at)
          @finish_at = msg.fetch('finish_at', @finish_at)
        end

        def appropriate_time_interval?
          current_time.between?(start_time, finish_time)
        end

        def start_time
          hour, min, sec = @start_at
          Time.utc(current_time.year, current_time.month, current_time.day, hour, min, sec)
        end

        def finish_time
          hour, min, sec = @finish_at
          Time.utc(current_time.year, current_time.month, current_time.day, hour, min, sec)
        end

        def current_time
          Time.now.utc
        end

        def next_start_time
          start_time + 86400
        end
      end
    end
  end
end
