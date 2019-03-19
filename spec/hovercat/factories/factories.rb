# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :message_retry, class: Hash do
    payload { 'teste payload' }
    header { 'teste header' }
    routing_key { 'teste routing key' }
    exchange { 'teste exchange' }

    initialize_with { attributes }
  end
end
