# frozen_string_literal: true

require 'hovercat/version'
require 'hovercat/gateways/message_gateway'
require 'hovercat/helpers/configuration'

module Hovercat
  CONFIG = Hovercat::Helpers::Configuration.new.configuration

  class Sender
    def self.publish(params)
      Hovercat::Gateways::MessageGateway.send(params)
    end
  end
end
