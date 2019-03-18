# frozen_string_literal: true

require 'sucker_punch'
require 'hovercat/publishers/publisher'

module Hovercat
  module Jobs
    class SuckerPunchJob
      include SuckerPunch::Job
      workers 4
      max_jobs 20

      def perform(params)
        response = Hovercat::Publishers::Publisher.new.publish(params)
        params[:retry_attempts] = increment_attempts(params)
        response.process_message(params) unless response.ok?
        retry_job(params) if params[:retry_attempts] >= Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_attempts']
      end

      def increment_attempts(params)
        return params[:retry_attempts] += 1 unless params[:retry_attempts].nil?

        1
      end

      def retry_job(params)
        self.class.perform_in(Hovercat::CONFIG['hovercat']['retries_in_rabbit_mq']['retry_delay_in_seconds'], params)
      end
    end
  end
end
