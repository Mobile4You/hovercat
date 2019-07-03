# frozen_string_literal: true

require 'connection_pool'

module Hovercat
  module Connectors
    class ChannelPool
      def channel_pool
        @channel_pool ||= ConnectionPool.new do
          @connection.create_channel
        end
      end
    end
  end
end
