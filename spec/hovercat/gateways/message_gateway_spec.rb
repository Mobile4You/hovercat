# frozen_string_literal: true

require 'hovercat/gateways/message_gateway'
require 'hovercat/publishers/publisher'
require 'hovercat/models/publish_successfully_response'
require 'hovercat/models/publish_failure_response'
require 'hovercat/errors/unable_to_send_message_error'
require 'bunny'

RSpec.describe Hovercat::Gateways::MessageGateway do
  let(:publisher) { double('Hovercat::Publishers::Publisher') }
  let(:message) { double('message', to_json: 'message_json', routing_key: 'message_routing_key') }
  subject { Hovercat::Gateways::MessageGateway.send(header: headers, exchange: exchange, publisher: publisher, message: message) }

  context 'Only event passed and successfully published' do
    let(:headers) { nil }
    let(:exchange) { nil }

    before do
      expect(Hovercat::Helpers::SenderMessageLoggerHelper).to receive(:log_success).once
    end

    it do
      expect(publisher).to receive(:publish)
        .with(payload: message.to_json, headers: {}, routing_key: message.routing_key,
              exchange: Hovercat::CONFIG['hovercat']['rabbitmq']['exchange'])
        .and_return(Hovercat::Models::PublishSuccessfullyResponse.new)
      subject
    end
  end

  context 'All params set and successfully published' do
    let(:headers) { { content_type: 'Application/json' } }
    let(:exchange) { 'test.exchange' }

    before do
      expect(Hovercat::Helpers::SenderMessageLoggerHelper).to receive(:log_success).once
    end

    it do
      expect(publisher).to receive(:publish).with(payload: message.to_json,
                                                  headers: headers, routing_key: message.routing_key, exchange: exchange)
                                            .and_return(Hovercat::Models::PublishSuccessfullyResponse.new)
      subject
    end
  end

  context 'All params set and successfully stored to retry in memory' do
    let(:headers) { { content_type: 'Application/json' } }
    let(:exchange) { 'test.exchange' }
    let(:sucker_punch_job) { Hovercat::Jobs::MemoryRetryMessagesSenderJob.new({}) }

    before do
      allow(Hovercat::Factories::RetryMessageJobFactory).to receive(:for).and_return(sucker_punch_job)
      expect(publisher).to receive(:publish).with(payload: message.to_json, headers: headers,
                                                  routing_key: message.routing_key, exchange: exchange)
                                            .and_return(Hovercat::Models::PublishFailureResponse.new)
      expect(Hovercat::Helpers::SenderMessageLoggerHelper).to receive(:log_will_retry).once
      expect(sucker_punch_job).to receive(:retry).once
    end

    it { expect(subject).to be_nil }
  end

  context 'All params set and successfully stored to retry in redis' do
    let(:headers) { { content_type: 'Application/json' } }
    let(:exchange) { 'test.exchange' }
    let(:redis_retry_job) { Hovercat::Jobs::RedisRetryMessagesSenderJob.new({}) }

    before do
      allow(Hovercat::Factories::RetryMessageJobFactory).to receive(:for).and_return(redis_retry_job)
      expect(publisher).to receive(:publish).with(payload: message.to_json, headers: headers,
                                                  routing_key: message.routing_key, exchange: exchange)
                                            .and_return(Hovercat::Models::PublishFailureResponse.new)
      expect(Hovercat::Helpers::SenderMessageLoggerHelper).to receive(:log_will_retry).once
      expect(redis_retry_job).to receive(:retry).once
    end

    it { expect(subject).to be_nil }
  end

  context 'when StandardError occurred and retry with redis' do
    let(:headers) { { content_type: 'Application/json' } }
    let(:exchange) { 'test.exchange' }
    let(:redis_retry_job) { Hovercat::Jobs::RedisRetryMessagesSenderJob.new({}) }

    before do
      allow(Hovercat::Factories::RetryMessageJobFactory).to receive(:for).and_return(redis_retry_job)
      expect(publisher).to receive(:publish).with(payload: message.to_json,
                                                  headers: headers, routing_key: message.routing_key, exchange: exchange)
                                            .and_raise(StandardError)
      expect(Hovercat::Helpers::SenderMessageLoggerHelper).to receive(:log_error).once
      expect(redis_retry_job).to receive(:retry).once
    end

    it { expect(subject).to be_nil }
  end
end
