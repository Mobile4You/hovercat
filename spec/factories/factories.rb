FactoryGirl.define do

  factory :message_retry, class: Hovercat::MessageRetry do
    payload {'teste payload'}
    header {'teste header'}
    routing_key {'teste routing key'}
    exchange {'teste exchange'}
  end

end