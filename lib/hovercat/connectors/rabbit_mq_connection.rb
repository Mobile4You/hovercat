# frozen_string_literal: true

require 'bunny'
require 'singleton'
require 'connection_pool'

module Hovercat
  module Connectors
    class RabbitMQConnection
      include Singleton

      def initialize
        @connection = Bunny.new(bunny_params).start
      end

      def channel_pool
        @channel_pool ||= ::ConnectionPool.new do
          @connection.create_channel
        end
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
    end
  end
end
