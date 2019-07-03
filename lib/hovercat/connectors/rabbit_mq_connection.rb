# frozen_string_literal: true

require 'bunny'
require 'singleton'

module Hovercat
  module Connectors
    class RabbitMQConnection
      include Singleton
      attr_reader :connection

      def initialize
        @connection = Bunny.new(bunny_params).start
      end

      def channel
        @channel = @connection.create_channel unless !@channel.nil? && @channel.open?

        @channel
      end

      def close_channel(channel)
        @channel.close_channel(channel)
      end

      def self.reset!
        @connection = nil
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
