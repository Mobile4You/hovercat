# frozen_string_literal: true

require 'hovercat'
require 'hovercat/jobs/memory_retry_messages_sender_job'

RSpec.describe Hovercat::Jobs::MemoryRetryMessagesSenderJob do
  let(:data) { {} }
  let(:sender_job) { Hovercat::Jobs::MemoryRetryMessagesSenderJob.new(data) }

  describe '.initialize' do
    subject { sender_job }

    context 'when initialize memory retry messages sender job' do
      it { expect(subject).to be_instance_of(Hovercat::Jobs::MemoryRetryMessagesSenderJob) }
      it { expect(subject.data).to eq(data) }
      it { expect(subject.seconds).to eq(30) }
    end
  end

  describe '.retry' do
    subject { sender_job.retry }

    before { expect(Hovercat.logger).to receive(:info).once }

    it do
      subject
      expect do
        Hovercat::Jobs::SuckerPunchJob.perform_in(30.seconds, data)
      end
    end
  end
end
