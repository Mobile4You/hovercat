require 'rails_helper'

RSpec.describe Hovercat::MessageRetry do

  subject {Hovercat::MessageRetry.new.too_many_retries?(attempts_limit)}

  context 'Nil limit attempts' do
    let(:attempts_limit) {nil}
    it {expect(subject).to be_truthy}
  end

  context '0 limit attempts' do
    let(:attempts_limit) {0}
    it {expect(subject).to be_truthy}
  end

  context '1 limit attempts' do
    let(:attempts_limit) {1}
    it {expect(subject).to be_falsey}
  end
end
