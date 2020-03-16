# frozen_string_literal: true

require 'hovercat'

module Hovercat
  module Instrumentations
    class Instrumentation
      def initialize(params = {})
        @message_attributes = params.to_json
        @routing_key = params.dig(:routing_key)
        @event_headers = params.dig(:headers)&.to_json
        @event_payload = params.dig(:payload)
        @logger = Hovercat.logger
      end

      def add_metric(metric, extra_params = {})
        @logger.info(metric_params(metric).merge!(extra_params).compact)
      end

      private

      def metric_params(metric)
        {
          message: 'metric', metric: metric,
          routing_key: @routing_key, event_headers: @event_headers,
          event_payload: @event_payload
        }
      end
    end
  end
end
