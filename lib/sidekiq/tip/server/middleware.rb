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
            worker.class.perform_in(wait_time, msg)
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

        def wait_time
          (start_time + 86400) - current_time
        end
      end
    end
  end
end
