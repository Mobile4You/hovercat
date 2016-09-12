require 'rails_helper'

RSpec.describe Hovercat::RepublishSuccessfullyResponse do

  subject! { Hovercat::RepublishSuccessfullyResponse.new.process_message(message) }

  context 'message removed' do
    let(:message) { create(:message_retry) }
    it { expect(Hovercat::MessageRetry.all).to be_empty }
  end

end