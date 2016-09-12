module Hovercat
  class RepublishFailureResponse
    def process_message(message)
      message.increment!(:retry_count)
      if message.too_many_retries?(Hovercat::CONFIG[:retry_attempts])
        Hovercat::TeamNotifierGateway.new.notify(message)
      end
    end
  end
end
