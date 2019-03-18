# frozen_string_literal: true

require 'hovercat/support/factory_bot'
require 'factory_bot'
require 'hovercat/factories/factories'

RSpec.configure do |_config|
  Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
end
