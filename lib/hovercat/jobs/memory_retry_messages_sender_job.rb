# frozen_string_literal: true

require 'hovercat/jobs/sucker_punch_job'
require 'hovercat/jobs/hovercat_retry_messages_sender_job'

module Hovercat
  module Jobs
    class MemoryRetryMessagesSenderJob < HovercatRetryMessagesSenderJob
      private

      def logger_params
        {
          message: "Using Sucker Punch to retry message in memory in #{@seconds} seconds",
          path: 'Hovercat::Jobs::MemoryRetryMessagesSenderJob',
          method: 'do_retry',
          call: 'Hovercat::Jobs::SuckerPunchJob.perform_in',
          params: @data
        }
      end

      def metric
        'event_retry_memory_strategy'
      end

      def do_retry
        Hovercat::Jobs::SuckerPunchJob.perform_in(@seconds, @data)
      end
    end
  end
end
