# frozen_string_literal: true

require 'hovercat'

module Hovercat
  module Jobs
    class HovercatRetryMessagesSenderJob
      attr_reader :data, :seconds

      def initialize(data = {})
        @data = data
        @seconds = Hovercat::CONFIG.dig('hovercat', 'retries_in_rabbit_mq', 'retry_delay_in_seconds') || 600
      end

      def retry
        log_retry
        do_retry
      end

      private

      def log_retry
        Hovercat.logger.info(logger_params)
      end

      def logger_params
        raise 'Must overwrite'
      end

      def do_retry
        raise 'Must overwrite'
      end
    end
  end
end
