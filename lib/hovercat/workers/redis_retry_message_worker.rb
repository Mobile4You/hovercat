# frozen_string_literal: true

require 'hovercat'
require 'hovercat/helpers/redis_retry_message_logger_helper'
require 'hovercat/errors/unable_to_send_message_error'
require 'hovercat/publishers/publisher'
require 'sidekiq'

module Hovercat
  module Workers
    class RedisRetryMessageWorker
      include Sidekiq::Worker

      sidekiq_retries_exhausted do |params|
        # TODO: What do we have to do in this case?
        message = 'Retry limit exceeded. Will not retry anymore.'
        Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_warn(message, params['args'][0])
      end

      sidekiq_retry_in do |_count, _exception|
        Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_delay_in_seconds'] || 600
      end

      def perform(params)
        response = Hovercat::Publishers::Publisher.new.publish(convert_params(params))
        if response.ok?
          Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_success(params)
        else
          Hovercat::Helpers::RedisRetryMessageLoggerHelper.log_failed(params)
          raise Hovercat::Errors::UnableToSendMessageError
        end
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
