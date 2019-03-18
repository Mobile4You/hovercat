# frozen_string_literal: true

require 'hovercat'
require 'hovercat/publishers/publisher'
require 'hovercat/errors/unable_to_send_message_error'
require 'json'
require 'hovercat/factories/retry_message_job_factory'

module Hovercat
  module Gateways
    class MessageGateway
      def self.send(params)
        headers = params[:headers] || {}
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

      def self.send_message(publisher, message_attributes)
        unless publisher.publish(message_attributes).ok?
          retry_delay_in_seconds = Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_delay_in_seconds']
          Hovercat::Factories::RetryMessageJobFactory.for.perform_later(message_attributes, retry_delay_in_seconds)
        end
      rescue StandardError => e
        raise Hovercat::Errors::UnableToSendMessageError, e.message
      end

      private_class_method :send_message
    end
  end
end
