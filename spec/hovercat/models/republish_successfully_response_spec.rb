# frozen_string_literal: true

require 'hovercat/models/publish_successfully_response'
require 'spec_helper'
require 'factory_bot'

RSpec.describe Hovercat::Models::PublishSuccessfullyResponse do
  subject { Hovercat::Models::PublishSuccessfullyResponse.new.process_message(message) }

  context 'message removed' do
    let(:message) { create(:message_retry) }
    it { expect(nil).to be_nil }
  end
end
