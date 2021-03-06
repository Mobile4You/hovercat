# frozen_string_literal: true

require 'json'
require 'hovercat'
require 'hovercat/publishers/publisher'
require 'hovercat/errors/unable_to_send_message_error'
require 'hovercat/factories/retry_message_job_factory'
require 'hovercat/instrumentations/sender_message_instrumentation'

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
          instrumentation = Hovercat::Instrumentations::SenderMessageInstrumentation.new(message_attributes)
          return instrumentation.log_success if publisher.publish(message_attributes).ok?

          instrumentation.log_will_retry
          handle_retry(message_attributes)
        rescue StandardError => e
          instrumentation.log_error(e)
          handle_retry(message_attributes)
        end

        def handle_retry(message_attributes)
          Hovercat::Factories::RetryMessageJobFactory.for(message_attributes).retry
        end
      end
    end
  end
end
