# frozen_string_literal: true

require 'hovercat'
require 'sidekiq'
require 'hovercat/helpers/redis_retry_message_logger_helper'

module Hovercat
  module Workers
    class RedisRetryMessageWorker
      include Sidekiq::Worker

      sidekiq_retries_exhausted do |msg|
        # TODO: O que fazer neste caso?
        message = 'Retry limit exceeded. Will not retry anymore.'
        params = msg['args'][0]
        Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_warn(message, params)
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
          Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_success(params)
        else
          Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_failed(params)
          raise Hovercat::Errors::UnableToSendMessageError
        end
      rescue StandardError => e
        # TODO: O que fazer neste caso?
        Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_error(e, params)
      end

      def convert_params(params)
        {
          payload: params['payload'], headers: params['headers'],
          exchange: params['exchange'], routing_key: params['routing_key']
        }
      end
    end
  end
end
