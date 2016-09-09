module Hovercat
  class RetryMessagesSenderJob < ApplicationJob
    queue_as :default

    def perform(publisher)
      publisher = publisher || HoverCat::Publisher.new
      begin
        messages = Hovercat::MessageRetry.order('updated_at').limit(HoverCat::CONFIG[:retry_number_of_messages])
        messages.each do |message|
          message.with_lock do
            publisher.republish(payload: message.payload, header: message.header, routing_key: message.routing_key, exchange: message.exchange).process_message(message)
          end
        end
      ensure
        self.class.set(wait: HoverCat::CONFIG[:retry_delay_in_s].second).perform_later(publisher)
      end
    end
  end
end
