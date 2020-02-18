# frozen_string_literal: true

require 'hovercat'
require 'hovercat/instrumentations/retry_strategy_instrumentation'

module Hovercat
  module Jobs
    class HovercatRetryMessagesSenderJob
      attr_reader :data, :seconds

      def initialize(data = {})
        @data = data
        @seconds = Hovercat::CONFIG.dig('hovercat', 'retries_in_rabbit_mq', 'retry_delay_in_seconds') || 600
        @instrumentation = Hovercat::Instrumentations::RetryStrategyInstrumentation.new(@data)
      end

      def retry
        @instrumentation.log_retry(logger_params, metric)
        do_retry
      end

      private

      def logger_params
        raise 'Must overwrite'
      end

      def metric
        raise 'Must overwrite'
      end

      def do_retry
        raise 'Must overwrite'
      end
    end
  end
end
