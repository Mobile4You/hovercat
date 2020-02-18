# frozen_string_literal: true

require 'hovercat'
require 'hovercat/instrumentations/instrumentation'

module Hovercat
  module Instrumentations
    class MemoryRetryMessageInstrumentation < Instrumentation
      def log_success
        message = 'Hovercat retried and sent message successfully'
        log(message)
        add_metric('event_retried_successfuly', retry_type: 'memory')
      end

      def log_failed
        message = 'Hovercat failed retrying to send message and will retry again'
        log(message)
        add_metric('event_retried_failed_and_will_retry', retry_type: 'memory')
      end

      def log_warn(message)
        @logger.warn(log_params(message, @message_attributes))
        add_metric('event_retried_limit_exceeded', retry_type: 'memory')
      end

      private

      def log(message)
        @logger.info(log_params(message, @message_attributes))
      end

      def log_params(message, params)
        {
          message: message,
          path: 'Hovercat::Jobs::SuckerPunchJob',
          method: 'perform',
          call: 'Hovercat::Publishers::Publisher.new.publish',
          params: params
        }
      end
    end
  end
end
