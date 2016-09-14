require 'rails_helper'

RSpec.describe Hovercat::RetryMessagesSender do

  let(:publisher) { Hovercat::Publisher.new }
  subject { Hovercat::RetryMessagesSender.new.send(publisher) }

  context 'with message retries' do
    let(:message) { create(:message_retry) }
    let(:publish_response) { Hovercat::PublishSuccessfullyResponse.new }

    before do
      expect(publish_response).to receive(:process_message).with(message)
      allow(publisher).to receive(:publish).and_return(publish_response)
    end

    it { subject }
  end

  context 'with message retries' do
    let(:publish_response) { Hovercat::PublishSuccessfullyResponse.new }

    before do
      FactoryGirl.create(:message_retry)
      FactoryGirl.create(:message_retry)
      FactoryGirl.create(:message_retry)
      expect(publish_response).to receive(:process_message).exactly(2).times
      allow(publisher).to receive(:publish).and_return(publish_response)

      Hovercat.config(retry_number_of_messages: 2)
    end

    it { subject }
  end

end
