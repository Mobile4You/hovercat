# frozen_string_literal: true

require 'hovercat'
require 'hovercat/instrumentations/instrumentation'

module Hovercat
  module Instrumentations
    class SenderMessageInstrumentation < Instrumentation
      def log_success
        message = 'Hovercat published message successfully'
        log(message)
        add_metric('event_posting_successfuly')
      end

      def log_will_retry
        message = 'Hovercat could not published message successfully and will retry'
        log(message)
        add_metric('event_posting_failed_and_will_retry')
      end

      def log_error(error)
        message = "An error [#{error.message}] occurred while sending message. Hovercat will retry."
        Hovercat.logger.error(log_params(message))
        add_metric('event_posting_error_and_will_retry')
      end

      private

      def log(message)
        Hovercat.logger.info(log_params(message))
      end

      def log_params(message)
        {
          message: message,
          path: 'Hovercat::Gateways::MessageGateway',
          method: 'send',
          call: 'Hovercat::Publishers::Publisher.new.publish',
          params: @message_attributes
        }
      end
    end
  end
end
