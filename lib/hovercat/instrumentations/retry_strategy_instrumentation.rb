# frozen_string_literal: true

require 'hovercat'
require 'hovercat/instrumentations/instrumentation'

module Hovercat
  module Instrumentations
    class RetryStrategyInstrumentation < Instrumentation
      def log_retry(logger_params, metric)
        Hovercat.logger.info(logger_params)
        add_metric(metric)
      end
    end
  end
end
