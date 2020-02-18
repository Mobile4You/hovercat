# frozen_string_literal: true

require 'hovercat'
require 'hovercat/jobs/memory_retry_messages_sender_job'
require 'hovercat/jobs/redis_retry_messages_sender_job'

module Hovercat
  module Factories
    class RetryMessageJobFactory
      class << self
        def for(data)
          return Hovercat::Jobs::RedisRetryMessagesSenderJob.new(data) if redis_retry?

          Hovercat::Jobs::MemoryRetryMessagesSenderJob.new(data)
        end

        private

        def redis_retry?
          !Hovercat::CONFIG['hovercat']['redis'].nil?
        end
      end
    end
  end
end
