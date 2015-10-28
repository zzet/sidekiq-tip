require "sidekiq/tip/version"
require "sidekiq/tip/server/middleware"
require 'pry'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Tip::Server::Middleware
  end
end
