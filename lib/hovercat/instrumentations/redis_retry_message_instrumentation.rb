# frozen_string_literal: true

require 'hovercat'
require 'hovercat/instrumentations/instrumentation'

module Hovercat
  module Instrumentations
    class RedisRetryMessageInstrumentation < Instrumentation
      def log_success
        message = 'Hovercat retried and sent message successfully'
        log(message)
        add_metric('event_retried_successfuly', retry_type: 'redis')
      end

      def log_failed
        message = 'Hovercat failed retrying to send message and will retry again'
        log(message)
        add_metric('event_retried_failed_and_will_retry', retry_type: 'redis')
      end

      def log_warn(message, params)
        Hovercat.logger.warn(log_params(message, params))
        add_metric('event_retried_limit_exceeded', retry_type: 'redis')
      end

      private

      def log(message)
        Hovercat.logger.info(log_params(message, @message_attributes))
      end

      def log_params(message, params)
        {
          message: message,
          path: 'Hovercat::Workers::RedisRetryMessageWorker',
          method: 'perform',
          call: 'Hovercat::Publishers::Publisher.new.publish',
          params: params
        }
      end
    end
  end
end
