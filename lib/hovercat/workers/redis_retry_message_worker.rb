# frozen_string_literal: true

require 'hovercat'
require 'sidekiq'

module Hovercat
  module Workers
    class RedisRetryMessageWorker
      include Sidekiq::Worker

      sidekiq_retries_exhausted do |msg|
         # TODO O que fazer neste caso?
         message = 'Retry limit exceeded. Will not retry anymore.'
         params = msg['args'][0]
         puts "PARAMS >>>> #{params}"
         log_warn(message, params)
      end

      sidekiq_retry_in do |_count, exception|
        case exception
        when Hovercat::Errors::UnableToSendMessageError
          Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_delay_in_seconds'] || 600
        end
      end

      def perform(params)
        response = Hovercat::Publishers::Publisher.new.publish(convert_params(params))
        if response.ok?
          log_retry_success(params)
        else
          log_retry_failed(params)
          raise Hovercat::Errors::UnableToSendMessageError
        end
      rescue StandardError => error
        # TODO O que fazer neste caso?
        log_error(error, params)
      end

      def convert_params(params)
        {
          payload: params['payload'],
          headers: params['headers'], routing_key: params['routing_key'],
          exchange: params['exchange']
        }
      end

      def log_retry_success(params)
        message = 'Hovercat retried and sent message successfully'
        log(message, params)
      end

      def log_retry_failed(params)
        message = 'Hovercat failed retrying to send message and will retry again'
        log(message, params)
      end

      def log_error(error, params)
        message = "An error [#{error.message}] occurred while retrying to send. message. Hovercat will not retry again."
        Hovercat.logger.error(log_params(message, params))
      end

      def log_warn(message, params)
        Hovercat.logger.warn(log_params(message, params))
      end

      def log(message, params)
        Hovercat.logger.info(log_params(message, params))
      end

      def log_params(message, params)
        {
          message: message,
          path: 'Hovercat::Workers::RedisRetryMessageWorker',
          method: 'perform',
          call: "Hovercat::Publishers::Publisher.new.publish",
          params: params
        }
      end
    end
  end
end
