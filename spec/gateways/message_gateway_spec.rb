require 'rails_helper'

RSpec.describe Hovercat::MessageGateway do

  let(:publisher) { Hovercat::Publisher.new }
  let(:message) { double('message', to_json: 'message_json', routing_key: 'message_routing_key') }
  subject { Hovercat::MessageGateway.new.send(header: header, exchange: exchange, publisher: publisher, message: message) }

  context 'Only event passed and successfully published' do
    let(:header) { nil }
    let(:exchange) { nil }

    it do
      expect(publisher).to receive(:publish).with(payload: message.to_json, header: {}, routing_key: message.routing_key, exchange: Hovercat::CONFIG[:exchange])
      subject
    end
  end

  context 'All params set and successfully published' do
    let(:header) { {content_type: 'Application/json'} }
    let(:exchange) { 'test.exchange' }

    it do
      expect(publisher).to receive(:publish).with(payload: message.to_json, header: header, routing_key: message.routing_key, exchange: exchange)
      subject
    end
  end

  context 'Only event passed and successfully stored to retry' do
    let(:header) { nil }
    let(:exchange) { nil }
    before do
      expect(publisher).to receive(:publish).with(payload: message.to_json, header: {}, routing_key: message.routing_key, exchange: Hovercat::CONFIG[:exchange]).and_return(false)
      subject
    end

    it { expect(Hovercat::MessageRetry.count).to be(1) }

    it do
      result_message_retry = Hovercat::MessageRetry.first
      expect(result_message_retry.payload).to eql(message.to_json)
      expect(result_message_retry.header).to eql('{}')
      expect(result_message_retry.routing_key).to eql(message.routing_key)
      expect(result_message_retry.exchange).to eql(Hovercat::CONFIG[:exchange])
      expect(result_message_retry.retry_count).to eql(0)
    end

  end

  context 'All params set and successfully stored to retry' do
    let(:header) { {content_type: 'Application/json'} }
    let(:exchange) { 'test.exchange' }
    before do
      expect(publisher).to receive(:publish).with(payload: message.to_json, header: header, routing_key: message.routing_key, exchange: exchange).and_return(false)
      subject
    end

    it { expect(Hovercat::MessageRetry.count).to be(1) }

    it do
      result_message_retry = Hovercat::MessageRetry.first
      expect(result_message_retry.payload).to eql(message.to_json)
      expect(result_message_retry.header).to eql('{:content_type=>"Application/json"}')
      expect(result_message_retry.routing_key).to eql(message.routing_key)
      expect(result_message_retry.exchange).to eql(exchange)
      expect(result_message_retry.retry_count).to eql(0)
    end

  end

  context 'All params set and failed to store message retry' do
    let(:header) { {content_type: 'Application/json'} }
    let(:exchange) { 'test.exchange' }
    before do
      expect(publisher).to receive(:publish).with(payload: message.to_json, header: header, routing_key: message.routing_key, exchange: exchange).and_return(false)

    end

    it do
      allow(Hovercat::MessageRetry).to receive(:create!).and_raise(ActiveRecord::RecordNotSaved)
      expect { subject }.to raise_error(Hovercat::UnableToSendMessageError)
    end

  end

end
