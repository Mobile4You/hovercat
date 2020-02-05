# frozen_string_literal: true

require 'hovercat'
require 'hovercat/publishers/publisher'
require 'hovercat/errors/unable_to_send_message_error'
require 'json'
require 'hovercat/factories/retry_message_job_factory'

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
          raise StandardError, "Erro"
          return log_success(message_attributes) if publisher.publish(message_attributes).ok?

          log_will_retry(message_attributes)
          handle_retry(message_attributes)
        rescue StandardError => error
          puts "AAAAAAAAAAA"
          # raise Hovercat::Errors::UnableToSendMessageError, e.message
          log_error(error, message_attributes)
          handle_retry(message_attributes)
        end

        def handle_retry(message_attributes)
          retry_delay_in_seconds = Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_delay_in_seconds']
          Hovercat::Factories::RetryMessageJobFactory.for.perform_later(retry_delay_in_seconds, message_attributes)
        end

        def log_success(message_attributes)
          message = 'Hovercat published message successfully'
          log(message, message_attributes)
        end

        def log_will_retry(message_attributes)
          message = 'Hovercat could not published message successfully and will retry'
          log(message, message_attributes)
        end

        def log_error(error, message_attributes)
          message = "An error [#{error.message}] occurred while sending message. Hovercat will retry."
          Hovercat.logger.error(log_params(message, message_attributes))
        end

        def log(message, message_attributes)
          Hovercat.logger.info(log_params(message, message_attributes))
        end


        def log_params(message, message_attributes)
          {
            message: message,
            path: 'Hovercat::Gateways::MessageGateway',
            method: 'send',
            call: "Hovercat::Publishers::Publisher.new.publish",
            params: message_attributes
          }
        end
      end
    end
  end
end
