# frozen_string_literal: true
require 'bunny'
require 'hovercat'
require 'hovercat/errors/unexpected_error'

module Hovercat
  module Connectors
    class BunnyConnector
      def initialize
        @connection = Hovercat::Connectors::RabbitMQConnection.instance.connection
      end

      def publish(params)
        exchange = @connection.channel.topic(exchange_name(params), durable: true)
        exchange.publish(params[:payload], routing_key: params[:routing_key], headers: params[:headers])
      rescue Timeout::Error => e
        raise Hovercat::Errors::UnexpectedError, e.message
      rescue StandardError => e
        raise Hovercat::Errors::UnexpectedError, e.message
      end

      private

      def exchange_name(params)
        params[:exchange] || Hovercat::CONFIG['hovercat']['rabbitmq']['exchange']
      end
    end
  end
end
