require 'rails_helper'

RSpec.describe Hovercat::RetryMessagesSenderJob do

  subject {HoverCat::RetryMessagesSenderJob.new.perform(publiser)}

  context 'publisher not passed' do
    let(:publiser) {nil}

  end
end
