# frozen_string_literal: true

require 'hovercat/jobs/memory_retry_messages_sender_job'
require 'spec_helper'
require 'factory_bot'

RSpec.describe Hovercat::Jobs::MemoryRetryMessagesSenderJob do
  subject { Hovercat::Jobs::MemoryRetryMessagesSenderJob.perform_later(message, 0.1) }

  context 'with message retries' do
    before do
    end
    let(:message) { build(:message_retry) }
    # let(:publish_response) { Hovercat::Models::PublishSuccessfullyResponse.new }

    # before do
    #   expect(publish_response).to receive(:process_message).with(message)
    #   allow(publisher).to receive(:publish).and_return(publish_response)
    # end

    latch = Concurrent::CountDownLatch.new
    latch.wait(6)
    it { expect(subject).to be_truthy }
  end
  #
  # context 'with message retries' do
  #   let(:publish_response) { Hovercat::Models::PublishSuccessfullyResponse.new }
  #
  #   before do
  #     FactoryBot.create(:message_retry)
  #     FactoryBot.create(:message_retry)
  #     FactoryBot.create(:message_retry)
  #     expect(publish_response).to receive(:process_message).exactly(2).times
  #     allow(publisher).to receive(:publish).and_return(publish_response)
  #
  #     Hovercat.config(retry_number_of_messages: 2)
  #   end
  #
  #   it { subject }
  # end
end
