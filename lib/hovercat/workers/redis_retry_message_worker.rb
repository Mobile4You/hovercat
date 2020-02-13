# frozen_string_literal: true

require 'hovercat'
require 'hovercat/helpers/redis_retry_message_logger_helper'
require 'hovercat/instrumentations/redis_retry_message_instrumentation'
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
        # TODO: ajustar o message attributes
        Hovercat::Instrumentations::RedisRetryMessageInstrumentation.new(message_attributes).log_warn(message, params['args'][0])
      end

      sidekiq_retry_in do |_count, _exception|
        Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_delay_in_seconds'] || 600
      end

      def perform(params)
        instrumentation = Hovercat::Instrumentations::RedisRetryMessageInstrumentation.new(params)
        response = Hovercat::Publishers::Publisher.new.publish(convert_params(params))
        if response.ok?
          instrumentation.log_success
        else
          instrumentation.log_failed
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
