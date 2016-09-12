require 'rails_helper'

RSpec.describe Hovercat::RetryMessagesSender do

  let(:publisher) { Hovercat::Publisher.new }
  subject { Hovercat::RetryMessagesSender.new.send(publisher) }

  context 'with message retries' do
    let(:message) { create(:message_retry) }
    let(:republish_response) { Hovercat::RepublishSuccessfullyResponse.new }

    before do
      expect(republish_response).to receive(:process_message).with(message)
      allow(publisher).to receive(:republish).and_return(republish_response)
    end

    it { subject }
  end

  context 'with message retries' do
    let(:republish_response) { Hovercat::RepublishSuccessfullyResponse.new }

    before do
      FactoryGirl.create(:message_retry)
      FactoryGirl.create(:message_retry)
      FactoryGirl.create(:message_retry)
      expect(republish_response).to receive(:process_message).exactly(2).times
      allow(publisher).to receive(:republish).and_return(republish_response)

      Hovercat.config(retry_number_of_messages: 2)
    end

    it { subject }
  end

end
