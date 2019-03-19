# frozen_string_literal: true

require 'spec_helper'
require 'hovercat/connectors/bunny_connector'
require 'json'
require 'bunny'

RSpec.describe Hovercat::Connectors::BunnyConnector do
  let(:headers) { { content_type: 'Application/json' } }
  let(:exchange) { 'test.exchange' }
  let(:routing_key) { 'routing.key' }
  let(:payload) { { param1: 'param1', param2: 'param2' }.to_json }
  let(:bunny_mock) { BunnyMock }
  let(:connector) { Hovercat::Connectors::BunnyConnector.new(bunny_mock) }

  context 'Successfully publish a message' do
    subject! { connector.publish(headers: headers, exchange: exchange, routing_key: routing_key, payload: payload) }

    it { expect(bunny_mock.connection.open?).to be_truthy }

    it { expect(bunny_mock.connection.initialize_params).to include(hosts: Hovercat::CONFIG['hovercat']['rabbitmq']['host']) }
    it { expect(bunny_mock.connection.initialize_params).to include(port: Hovercat::CONFIG['hovercat']['rabbitmq']['port']) }
    it { expect(bunny_mock.connection.initialize_params).to include(vhost: Hovercat::CONFIG['hovercat']['rabbitmq']['vhost']) }
    it { expect(bunny_mock.connection.initialize_params).to include(user: Hovercat::CONFIG['hovercat']['rabbitmq']['user']) }
    it { expect(bunny_mock.connection.initialize_params).to include(password: Hovercat::CONFIG['hovercat']['rabbitmq']['password']) }

    it { expect(bunny_mock.connection.channel.exchange.name).to eql(exchange) }
    it { expect(bunny_mock.connection.channel.exchange.opts).to include(durable: true) }
    it { expect(bunny_mock.connection.channel.exchange.payload).to eql(payload) }
    it { expect(bunny_mock.connection.channel.exchange.publish_opts).to include(routing_key: routing_key) }
    it { expect(bunny_mock.connection.channel.exchange.publish_opts).to include(headers: headers) }

    it { expect(bunny_mock.connection.closed?).to be_truthy }
  end

  context 'Throw exception starting a connection' do
    before do
      connector
      bunny_mock.connection.throw_error_on_start_connection
    end

    subject { connector.publish(headers: headers, exchange: exchange, routing_key: routing_key, payload: payload) }

    it { expect { subject }.to raise_exception(Hovercat::Errors::UnexpectedError) }
  end

  context 'Throw exception publishing a message' do
    before do
      connector
      allow_any_instance_of(BunnyExchangeMock).to receive(:publish).and_raise(Bunny::ConnectionLevelException)
    end

    subject { connector.publish(headers: headers, exchange: exchange, routing_key: routing_key, payload: payload) }

    it { expect { subject }.to raise_exception(Hovercat::Errors::UnexpectedError) }
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
      @initialize_params = params
      @started = false
      @closed = false
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

    attr_reader :channel

    def throw_error_on_start_connection
      @start_connection_error = Bunny::TCPConnectionFailed
    end
  end

  class BunnyChannelMock
    def topic(name, opts = {})
      @exchange = BunnyExchangeMock.new(name, opts)
    end

    attr_reader :exchange
  end

  class BunnyExchangeMock
    attr_reader :name, :opts, :payload, :publish_opts

    def initialize(name, opts = {})
      @name = name
      @opts = opts
    end

    def publish(payload, opts = {})
      @payload = payload
      @publish_opts = opts
    end

    def throw_error_on_publish
      @publish_error = Bunny::ConnectionLevelException
    end
  end
end
