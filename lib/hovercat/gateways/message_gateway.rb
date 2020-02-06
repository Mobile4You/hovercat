# frozen_string_literal: true

require 'hovercat'
require 'hovercat/publishers/publisher'
require 'hovercat/errors/unable_to_send_message_error'
require 'json'
require 'hovercat/factories/retry_message_job_factory'
require 'hovercat/helpers/sender_message_logger_helper'

module Hovercat
  module Gateways
    class MessageGateway
      class << self
        def send(params)
          headers = params[:header] || {}
          exchange = params[:exchange] || Hovercat::CONFIG['hovercat']['rabbitmq']['exchange']
          publisher = params[:publisher] || Hovercat::Publishers::Publisher.new
          message = params[:message]

          message_attributes = {
            payload: message.to_json,
            headers: headers, routing_key: message.routing_key,
            exchange: exchange
          }
          send_message(publisher, message_attributes)
        end

        private

        def send_message(publisher, message_attributes)
          return Hovercat::Helpers::SenderMessageLoggerHelper.log_success(message_attributes) if publisher.publish(message_attributes).ok?

          Hovercat::Helpers::SenderMessageLoggerHelper.log_will_retry(message_attributes)
          handle_retry(message_attributes)
        rescue StandardError => e
          # raise Hovercat::Errors::UnableToSendMessageError, e.message
          Hovercat::Helpers::SenderMessageLoggerHelper.log_error(e, message_attributes)
          handle_retry(message_attributes)
        end

        def handle_retry(message_attributes)
          Hovercat::Factories::RetryMessageJobFactory.for(message_attributes).retry
        end
      end
    end
  end
end
