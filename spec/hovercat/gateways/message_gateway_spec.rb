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
  subject { Hovercat::Gateways::MessageGateway.send(headers: headers, exchange: exchange, publisher: publisher, message: message) }

  context 'Only event passed and successfully published' do
    let(:headers) { nil }
    let(:exchange) { nil }

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

    it do
      expect(publisher).to receive(:publish).with(payload: message.to_json,
                                                  headers: headers, routing_key: message.routing_key, exchange: exchange)
                                            .and_return(Hovercat::Models::PublishSuccessfullyResponse.new)
      subject
    end
  end

  context 'All params set and successfully stored to retry' do
    let(:headers) { { content_type: 'Application/json' } }
    let(:exchange) { 'test.exchange' }
    before do
      expect(publisher).to receive(:publish).with(payload: message.to_json, headers: headers,
                                                  routing_key: message.routing_key, exchange: exchange)
                                            .and_return(Hovercat::Models::PublishFailureResponse.new)
      subject
    end

    it do
      expect(subject).to be_truthy
    end
  end

  context 'All params set and failed to store message retry' do
    let(:headers) { { content_type: 'Application/json' } }
    let(:exchange) { 'test.exchange' }
    before do
      expect(publisher).to receive(:publish).with(payload: message.to_json,
                                                  headers: headers, routing_key: message.routing_key, exchange: exchange)
                                            .and_raise(StandardError)
    end

    it do
      expect { subject }.to raise_error(Hovercat::Errors::UnableToSendMessageError)
    end
  end
end
