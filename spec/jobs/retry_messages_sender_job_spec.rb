require 'rails_helper'

RSpec.describe Hovercat::RetryMessagesSenderJob do

  subject {HoverCat::RetryMessagesSenderJob.new.perform(publisher)}

  context 'publisher not passed and ' do
    let(:publisher) {nil}
  end


  context 'without message retries' do
  end

  context 'with'

end
