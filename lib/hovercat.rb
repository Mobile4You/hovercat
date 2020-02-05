# frozen_string_literal: true

require 'hovercat/version'
require 'hovercat/gateways/message_gateway'
require 'hovercat/helpers/configuration'
require 'hovercat/connectors/bunny_connector'
require 'hovercat/connectors/rabbit_mq_connection'
require 'hovercat/errors/unable_to_send_message_error'
require 'hovercat/errors/missing_configuration_file_error'
require 'hovercat/errors/unexpected_error'
require 'hovercat/factories/retry_message_job_factory'
require 'hovercat/gateways/message_gateway'
require 'hovercat/gateways/team_notifier_gateway'
require 'hovercat/models/message'
require 'hovercat/models/publish_failure_response'
require 'hovercat/models/publish_successfully_response'
require 'hovercat/workers/redis_retry_message_worker'
require 'logger'

module Hovercat
  CONFIG = Hovercat::Helpers::Configuration.new.configuration

  class << self
    attr_accessor :logger
  end

  self.logger = Logger.new(STDOUT)

  class Sender
    def self.publish(params)
      Hovercat::Gateways::MessageGateway.send(params)
    end
  end
end
