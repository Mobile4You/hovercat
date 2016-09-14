module Hovercat
  class RetryMessagesSender
    def send(publisher)
      messages = Hovercat::MessageRetry.order('updated_at').limit(Hovercat::CONFIG[:retry_number_of_messages])
      messages.each do |message|
        message.with_lock do
          publisher.publish(payload: message.payload, header: message.header, routing_key: message.routing_key, exchange: message.exchange).process_message(message)
        end
      end
    end
  end
end