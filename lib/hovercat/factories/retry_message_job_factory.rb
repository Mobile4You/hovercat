# frozen_string_literal: true

require 'hovercat/jobs/memory_retry_messages_sender_job'
require 'hovercat'

module Hovercat
  module Factories
    class RetryMessageJobFactory
      def self.for
        return Hovercat::Jobs::MemoryRetryMessagesSenderJob if memory_retry?

        nil
      end

      def self.memory_retry?
        Hovercat::CONFIG['hovercat']['redis'].nil?
      end

      private_class_method :memory_retry?
    end
  end
end
