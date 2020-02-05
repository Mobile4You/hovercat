# frozen_string_literal: true

require 'hovercat/jobs/sucker_punch_job'

module Hovercat
  module Jobs
    class MemoryRetryMessagesSenderJob
      class << self
        def perform_later(seconds, data)
          log_retry(seconds, data)
          Hovercat::Jobs::SuckerPunchJob.perform_in(seconds, data)
        end

        private

        def log_retry(seconds, data)
          Hovercat.logger.info(
            message: "Using Sucker Punch to retry message in memory in #{seconds} seconds",
            path: 'Hovercat::Jobs::MemoryRetryMessagesSenderJob',
            method: 'perform_later',
            call: 'Hovercat::Jobs::SuckerPunchJob.perform_in',
            params: data
          )
        end
      end
    end
  end
end
