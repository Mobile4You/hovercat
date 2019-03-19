# frozen_string_literal: true

require 'hovercat'
require 'hovercat/gateways/team_notifier_gateway'

module Hovercat
  module Models
    class PublishFailureResponse
      def process_message(message)
        Hovercat::Gateways::TeamNotifierGateway.new.notify(message) if max_retry?(message)
      end

      def max_retry?(message)
        message[:retry_attempts] >= Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_attempts']
      end

      def ok?
        false
      end
    end
  end
end
