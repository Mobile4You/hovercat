# frozen_string_literal: true

require 'hovercat/jobs/sucker_punch_job'

module Hovercat
  module Jobs
    class MemoryRetryMessagesSenderJob
      def self.perform_later(data, seconds)
        Hovercat::Jobs::SuckerPunchJob.perform_in(seconds, data)
      end
    end
  end
end
