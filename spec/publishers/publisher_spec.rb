require 'rails_helper'

RSpec.describe Hovercat::Publisher do


  context '#publish' do
    let(:header) { {content_type: 'Application/json'} }
    let(:exchange) { 'test.exchange' }
    let(:routing_key) { 'routing.key' }
    let(:payload) { {param1: 'param1', param2: 'param2'}.as_json }


    subject! { Hovercat::Publisher.new(connector).publish(header: header, exchange: exchange, routing_key: routing_key, payload: payload) }

    context 'Message published' do
      let(:connector) { BunnyConnectorMock.new }

      it { is_expected.to be_ok }
      it { expect(connector.header).to eql(header) }
      it { expect(connector.exchange).to eql(exchange) }
      it { expect(connector.routing_key).to eql(routing_key) }
      it { expect(connector.payload).to eql(payload) }
    end

    context 'Unexpected error on publish' do
      let(:connector) { BunnyConnectorMock.new.throw_error_on_publish }

      it { is_expected.not_to be_ok }
      it { expect(connector.header).to eql(header) }
      it { expect(connector.exchange).to eql(exchange) }
      it { expect(connector.routing_key).to eql(routing_key) }
      it { expect(connector.payload).to eql(payload) }
    end

    class BunnyConnectorMock
      attr_reader :header, :exchange, :routing_key, :payload

      def publish(params)
        @header, @exchange, @routing_key, @payload = params[:header], params[:exchange], params[:routing_key], params[:payload]

        raise @error if @error
      end

      def throw_error_on_publish
        @error = Hovercat::UnexpectedError.new
        self
      end

    end
  end
end