# frozen_string_literal: true

require 'hovercat/models/publish_failure_response'
require 'hovercat/gateways/team_notifier_gateway'
require 'spec_helper'
require 'factory_bot'

RSpec.describe Hovercat::Models::PublishFailureResponse do
  subject { Hovercat::Models::PublishFailureResponse.new.process_message(message) }

  context 'When retry count below limit' do
    let(:message) { FactoryBot.build(:message_retry, retry_attempts: 2) }
    it { expect(subject).to be_falsey }
  end

  context 'When retry count above limit' do
    before { allow_any_instance_of(Hovercat::Gateways::TeamNotifierGateway).to receive(:notify).with(message).and_return(true) }
    let(:message) { FactoryBot.build(:message_retry, retry_attempts: 3) }
    it { expect(subject).to be_truthy }
  end
end
