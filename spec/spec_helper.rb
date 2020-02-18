# frozen_string_literal: true

require 'hovercat/support/factory_bot'
require 'factory_bot'
require 'hovercat/factories/factories'
require 'sidekiq'

RSpec.configure do |config|
  Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
