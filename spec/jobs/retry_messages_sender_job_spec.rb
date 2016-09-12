require 'rails_helper'

RSpec.describe Hovercat::RetryMessagesSenderJob do

  subject { Hovercat::RetryMessagesSenderJob.new.perform(publisher) }
  before { ActiveJob::Base.queue_adapter = :test }
  let(:perform_job) do
    subject
    expect(Hovercat::RetryMessagesSenderJob).to have_been_enqueued
  end

  context 'publisher not passed' do
    let(:publisher) { nil }
    before { allow_any_instance_of(Hovercat::RetryMessagesSender).to receive(:send) }
    it { perform_job }
  end

  context 'without errors' do
    let(:publisher) { Hovercat::Publisher.new }
    before { allow_any_instance_of(Hovercat::RetryMessagesSender).to receive(:send) }
    it { perform_job }
  end

  context 'with errors' do
    let(:publisher) { Hovercat::Publisher.new }
    before { allow_any_instance_of(Hovercat::RetryMessagesSender).to receive(:send).and_raise(StandardError.new) }
    it { perform_job }
  end

end
