# frozen_string_literal: true

require 'hovercat'
require 'hovercat/jobs/hovercat_retry_messages_sender_job'
require 'hovercat/workers/redis_retry_message_worker'

module Hovercat
  module Jobs
    class RedisRetryMessagesSenderJob < HovercatRetryMessagesSenderJob
      attr_reader :queue_name, :retry_attempts

      def initialize(data = {})
        super
        @queue_name = Hovercat::CONFIG.dig('hovercat', 'redis', 'retry_queue_name')&.to_sym || :default
        @retry_attempts = Hovercat::CONFIG.dig('hovercat', 'retries_in_rabbit_mq', 'retry_attempts') || 0
      end

      private

      def logger_params
        {
          message: "Using Sidekiq with Redis to retry message in #{@seconds} seconds",
          path: 'Hovercat::Jobs::RedisRetryMessagesSenderJob',
          method: 'do_retry',
          call: 'Hovercat::Workers::RedisRetryMessageWorker.perform_in',
          params: @data
        }
      end

      def do_retry
        Hovercat::Workers::RedisRetryMessageWorker
          .set(queue: @queue_name, retry: @retry_attempts)
          .perform_in(@seconds.seconds, @data)
      end
    end
  end
end
