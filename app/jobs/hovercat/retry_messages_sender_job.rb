module Hovercat
  class RetryMessagesSenderJob < ApplicationJob
    queue_as :default

    def perform(publisher)
      publisher = publisher || Hovercat::Publisher.new
      begin
        Hovercat::RetryMessagesSender.new.send(publisher)
      rescue StandardError
      ensure
        self.class.set(wait: Hovercat::CONFIG[:retry_delay_in_s].second).perform_later()
      end
    end
  end
end
