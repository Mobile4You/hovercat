# frozen_string_literal: true

require 'hovercat'
require 'hovercat/jobs/redis_retry_messages_sender_job'
require 'hovercat/workers/redis_retry_message_worker'
require 'active_support'
require 'active_support/core_ext'
require 'sidekiq/testing'

RSpec.describe Hovercat::Jobs::RedisRetryMessagesSenderJob do
  let(:data) { {} }
  let(:sender_job) { Hovercat::Jobs::RedisRetryMessagesSenderJob.new(data) }

  describe '.initialize' do
    subject { sender_job }

    context 'when initialize redis retry messages sender job' do
      it { expect(subject).to be_instance_of(Hovercat::Jobs::RedisRetryMessagesSenderJob) }
      it { expect(subject.data).to eq(data) }
      it { expect(subject.seconds).to eq(30) }
      it { expect(subject.queue_name).to eq(:retry_queue_name) }
      it { expect(subject.retry_attempts).to eq(3) }
    end
  end

  describe '.retry' do
    subject { sender_job.retry }

    before { expect(Hovercat.logger).to receive(:info).once }

    it do
      subject
      expect do
        Hovercat::Workers::RedisRetryMessageWorker.perform_in(30.seconds, data)
      end.to change(Hovercat::Workers::RedisRetryMessageWorker.jobs, :size).by 1
    end
  end
end
