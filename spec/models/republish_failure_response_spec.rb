require 'rails_helper'

RSpec.describe Hovercat::RepublishFailureResponse do

  subject { Hovercat::RepublishFailureResponse.new.process_message(message) }

  context 'When retry count below limit' do
    let(:message) { create(:message_retry) }
    it do
      subject
      expect(Hovercat::MessageRetry.first.retry_count).to eql(1)
    end
  end

  context 'When retry count above limit' do
    let(:message) { create(:message_retry, retry_count: 4) }

    before do
      expect_any_instance_of(Hovercat::TeamNotifierGateway).to receive(:notify).with(message)
    end

    it do
      subject
      expect(Hovercat::MessageRetry.first.retry_count).to eql(5)
    end
  end

end