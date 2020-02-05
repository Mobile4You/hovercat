# frozen_string_literal: true

require 'hovercat'
require 'hovercat/workers/redis_retry_message_worker'

module Hovercat
  module Jobs
    class RedisRetryMessagesSenderJob
      class << self
        def perform_later(seconds, data)
          log_retry(seconds, data)
          Hovercat::Workers::RedisRetryMessageWorker
            .set(queue: queue_name, retry: retry_attempts)
            .perform_in(seconds.seconds, data)
        end

        private

        def log_retry(seconds, data)
          Hovercat.logger.info(
            message: "Using Sidekiq with Redis to retry message in #{seconds} seconds",
            path: 'Hovercat::Jobs::RedisRetryMessagesSenderJob',
            method: 'perform_later',
            call: 'Hovercat::Workers::RedisRetryMessageWorker.perform_in',
            params: data
          )
        end

        def queue_name
          Hovercat::CONFIG['hovercat']['redis']['retry_queue_name']&.to_sym || :default
        end

        def retry_attempts
          Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_attempts'] || 0
        end
      end
    end
  end
end
