# frozen_string_literal: true

require 'hovercat'

module Hovercat
  module Helpers
    class SenderMessageLoggerHelper
      class << self
        def log_success(message_attributes)
          message = 'Hovercat published message successfully'
          log(message, message_attributes)
        end

        def log_will_retry(message_attributes)
          message = 'Hovercat could not published message successfully and will retry'
          log(message, message_attributes)
        end

        def log_error(error, message_attributes)
          message = "An error [#{error.message}] occurred while sending message. Hovercat will retry."
          Hovercat.logger.error(log_params(message, message_attributes))
        end

        private

        def log(message, message_attributes)
          Hovercat.logger.info(log_params(message, message_attributes))
        end

        def log_params(message, message_attributes)
          {
            message: message,
            path: 'Hovercat::Gateways::MessageGateway',
            method: 'send',
            call: 'Hovercat::Publishers::Publisher.new.publish',
            params: message_attributes
          }
        end
      end
    end
  end
end
