require 'rails_helper'

RSpec.describe Hovercat::Publisher do

  context '#republish' do
    let(:params) { {} }
    subject {Hovercat::Publisher.new.republish(params)}

    it 'RepublishFailureResponse returned' do
      allow_any_instance_of(Hovercat::Publisher).to receive(:publish).with(params).and_return(false)
      expect(should be_an_instance_of(Hovercat::RepublishFailureResponse))
    end

    it 'RepublishSuccessfullyResponse returned' do
      allow_any_instance_of(Hovercat::Publisher).to receive(:publish).with(params).and_return(true)
      expect(should be_an_instance_of(Hovercat::RepublishSuccessfullyResponse))
    end

  end

end