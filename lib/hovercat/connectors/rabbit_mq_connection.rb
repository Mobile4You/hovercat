# frozen_string_literal: true

require 'bunny'
require 'singleton'

module Hovercat
  module Connectors
    class RabbitMQConnection
      include Singleton

      def initialize
        @connection = Bunny.new(bunny_params).start
        @channel = @connection.create_channel
      end

      def channel
        @channel = @connection.create_channel unless !@channel.nil? && @channel.open?

        @channel
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
