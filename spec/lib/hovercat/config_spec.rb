require 'rails_helper'

describe HoverCat::Config do

  let(:config) { HoverCat::Config.new.configs }

  context 'default configs' do
    it { expect(config[:exchange]).to eql('thundercats.events') }
    it { expect(config[:host]).to eql('localhost') }
    it { expect(config[:port]).to eql('5672') }
    it { expect(config[:vhost]).to eql('/') }
    it { expect(config[:user]).to eql('guest') }
    it { expect(config[:password]).to eql('guest') }
    it { expect(config[:log_file]).to eql('hovercat.log') }
    it { expect(config[:retry_attempts]).to eql('3') }
    it { expect(config[:retry_delay_in_s]).to eql('600') }
    it { expect(config[:retry_number_of_messages]).to eql('500') }
  end

  context 'client empty configs' do
    before do
      config.merge!({})
    end
    it { expect(config[:exchange]).to eql('thundercats.events') }
    it { expect(config[:host]).to eql('localhost') }
    it { expect(config[:port]).to eql('5672') }
    it { expect(config[:vhost]).to eql('/') }
    it { expect(config[:user]).to eql('guest') }
    it { expect(config[:password]).to eql('guest') }
    it { expect(config[:log_file]).to eql('hovercat.log') }
    it { expect(config[:retry_attempts]).to eql('3') }
    it { expect(config[:retry_delay_in_s]).to eql('600') }
    it { expect(config[:retry_number_of_messages]).to eql('500') }
  end

  context 'client empty configs' do
    let(:new_configs) { {exchange: 'test.events', user: 'new_user', password: 'new_pass'} }

    before do
      config.merge!(new_configs)
    end
    it { expect(config[:exchange]).to eql(new_configs[:exchange]) }
    it { expect(config[:host]).to eql('localhost') }
    it { expect(config[:port]).to eql('5672') }
    it { expect(config[:vhost]).to eql('/') }
    it { expect(config[:user]).to eql(new_configs[:user]) }
    it { expect(config[:password]).to eql(new_configs[:password]) }
    it { expect(config[:log_file]).to eql('hovercat.log') }
    it { expect(config[:retry_attempts]).to eql('3') }
    it { expect(config[:retry_delay_in_s]).to eql('600') }
    it { expect(config[:retry_number_of_messages]).to eql('500') }
  end
end