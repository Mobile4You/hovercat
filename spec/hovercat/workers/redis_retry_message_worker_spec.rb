# frozen_string_literal: true

require 'hovercat'
require 'hovercat/publishers/publisher'
require 'hovercat/workers/redis_retry_message_worker'
require 'hovercat/helpers/redis_retry_message_logger_helper'
require 'active_support'
require 'active_support/core_ext'
require 'sidekiq/testing'

RSpec.describe Hovercat::Workers::RedisRetryMessageWorker do
  let(:queue_name) { :retry_queue_name }
  let(:retry_attempts) { 3 }
  let(:delay) { 30 }
  let(:data) { {} }

  subject do
    Hovercat::Workers::RedisRetryMessageWorker
      .set(queue: queue_name, retry: retry_attempts)
      .perform_in(delay.seconds, data)
  end

  before do
    Sidekiq::Testing.inline!
    allow_any_instance_of(Hovercat::Publishers::Publisher).to receive(:publish).and_return(publisher_result)
  end

  context 'when retry worked in the first try' do
    let(:publisher_result) { Hovercat::Models::PublishSuccessfullyResponse.new }

    it do
      expect(Hovercat::Helpers::RedisRetryMessageLoggerHelper).to receive(:log_success).with(data).once
      subject
    end
  end

  context 'when retry does not worked' do
    let(:publisher_result) { Hovercat::Models::PublishFailureResponse.new }

    it do
      expect(Hovercat::Helpers::RedisRetryMessageLoggerHelper).to receive(:log_failed).with(data).once
      expect { subject }.to raise_error(Hovercat::Errors::UnableToSendMessageError)
    end
  end
end
