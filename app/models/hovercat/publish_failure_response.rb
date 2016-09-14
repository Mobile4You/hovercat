module Hovercat
  class PublishFailureResponse
    def process_message(message)
      message.increment!(:retry_count)
      if message.too_many_retries?(Hovercat::CONFIG[:retry_attempts])
        Hovercat::TeamNotifierGateway.new.notify(message)
      end
    end

    def ok?
      false
    end
  end
end
