# frozen_string_literal: true

require 'bunny'
require 'hovercat'
require 'hovercat/errors/unexpected_error'

module Hovercat
  module Connectors
    class BunnyConnector
      def initialize(gem = Bunny)
        @connection = gem.new(bunny_params)
      end

      def publish(params)
        @connection.start
        exchange = @connection.create_channel.topic(exchange_name(params), durable: true)
        exchange.publish(params[:payload], routing_key: params[:routing_key], headers: params[:headers])
      rescue Timeout::Error => e
        raise Hovercat::Errors::UnexpectedError, e.message
      rescue StandardError => e
        raise Hovercat::Errors::UnexpectedError, e.message
      ensure
        @connection.close if @connection.open?
      end

      private

      def bunny_params
        {
          hosts: Hovercat::CONFIG['hovercat']['rabbitmq']['host'],
          port: Hovercat::CONFIG['hovercat']['rabbitmq']['port'],
          vhost: Hovercat::CONFIG['hovercat']['rabbitmq']['vhost'],
          user: Hovercat::CONFIG['hovercat']['rabbitmq']['user'],
          password: Hovercat::CONFIG['hovercat']['rabbitmq']['password']
        }
      end

      def exchange_name(params)
        params[:exchange] || Hovercat::CONFIG['hovercat']['rabbitmq']['exchange']
      end
    end
  end
end
