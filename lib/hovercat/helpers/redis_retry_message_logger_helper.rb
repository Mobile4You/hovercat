# frozen_string_literal: true

require 'hovercat'

module Hovercat
  module Helpers
    class RedisRetryMessageLoggerHelper
      class << self
        def log_success(params)
          message = 'Hovercat retried and sent message successfully'
          log(message, params)
        end

        def log_failed(params)
          message = 'Hovercat failed retrying to send message and will retry again'
          log(message, params)
        end

        def log_warn(message, params)
          Hovercat.logger.warn(log_params(message, params))
        end

        private

        def log(message, params)
          Hovercat.logger.info(log_params(message, params))
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
end
