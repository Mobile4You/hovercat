require 'rails_helper'

RSpec.describe Hovercat::BunnyConnector do

  let(:header) { {content_type: 'Application/json'} }
  let(:exchange) { 'test.exchange' }
  let(:routing_key) { 'routing.key' }
  let(:payload) { {param1: 'param1', param2: 'param2'}.as_json }
  let(:bunny_mock) { BunnyMock }
  let(:connector) { Hovercat::BunnyConnector.new(bunny_mock) }

  context 'Successfully publish a message' do
    subject! { connector.publish(header: header, exchange: exchange, routing_key: routing_key, payload: payload) }

    it { expect(bunny_mock.connection.open?).to be_truthy }

    it { expect(bunny_mock.connection.initialize_params).to include(host: Hovercat::CONFIG[:host]) }
    it { expect(bunny_mock.connection.initialize_params).to include(port: Hovercat::CONFIG[:port]) }
    it { expect(bunny_mock.connection.initialize_params).to include(vhost: Hovercat::CONFIG[:vhost]) }
    it { expect(bunny_mock.connection.initialize_params).to include(user: Hovercat::CONFIG[:user]) }
    it { expect(bunny_mock.connection.initialize_params).to include(password: Hovercat::CONFIG[:password]) }

    it { expect(bunny_mock.connection.channel.exchange.name).to eql(exchange) }
    it { expect(bunny_mock.connection.channel.exchange.opts).to include(durable: true) }
    it { expect(bunny_mock.connection.channel.exchange.payload).to eql(payload) }
    it { expect(bunny_mock.connection.channel.exchange.publish_opts).to include(routing_key: routing_key) }
    it { expect(bunny_mock.connection.channel.exchange.publish_opts).to include(headers: header) }

    it { expect(bunny_mock.connection.closed?).to be_truthy }
  end

  context 'Throw exception starting a connection' do
    before do
      connector
      bunny_mock.connection.throw_error_on_start_connection
    end

    subject { connector.publish(header: header, exchange: exchange, routing_key: routing_key, payload: payload) }

    it { expect{subject}.to raise_exception(Hovercat::UnexpectedError) }
  end

  context 'Throw exception publishing a message' do
    before do
      connector
      allow_any_instance_of(BunnyExchangeMock).to receive(:publish).and_raise(Bunny::ConnectionLevelException)
    end

    subject { connector.publish(header: header, exchange: exchange, routing_key: routing_key, payload: payload) }

    it { expect{subject}.to raise_exception(Hovercat::UnexpectedError) }
  end

  module BunnyMock
    def self.new(params)
      @connection = BunnyConnectionMock.new(params)
    end

    def self.connection
      @connection
    end
  end

  class BunnyConnectionMock
    attr_reader :initialize_params

    def initialize(params)
      @initialize_params, @started, @closed = params, false, false
    end

    def start
      raise @start_connection_error if @start_connection_error
      @started = true
    end

    def close
      @closed = true
    end

    def open?
      @started
    end

    def closed?
      @closed
    end

    def create_channel
      @channel = BunnyChannelMock.new
    end

    def channel
      @channel
    end

    def throw_error_on_start_connection
      @start_connection_error = Bunny::TCPConnectionFailed
    end
  end

  class BunnyChannelMock
    def topic(name, opts = {})
      @exchange = BunnyExchangeMock.new(name, opts)
    end

    def exchange
      @exchange
    end
  end

  class BunnyExchangeMock
    attr_reader :name, :opts, :payload, :publish_opts

    def initialize(name, opts = {})
      @name, @opts = name, opts
    end

    def publish(payload, opts = {})
      @payload, @publish_opts = payload, opts
    end

    def throw_error_on_publish
      @publish_error = Bunny::ConnectionLevelException
    end
  end
end