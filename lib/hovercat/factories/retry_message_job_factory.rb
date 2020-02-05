# frozen_string_literal: true

require 'hovercat/jobs/memory_retry_messages_sender_job'
require 'hovercat/jobs/redis_retry_messages_sender_job'
require 'hovercat'

module Hovercat
  module Factories
    class RetryMessageJobFactory
      class << self
        def for
          return Hovercat::Jobs::RedisRetryMessagesSenderJob if redis_retry?

          Hovercat::Jobs::MemoryRetryMessagesSenderJob
        end

        private

        def redis_retry?
          !Hovercat::CONFIG['hovercat']['redis'].nil?
        end
      end
    end
  end
end
