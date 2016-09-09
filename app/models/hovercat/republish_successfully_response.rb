module Hovercat
  class RepublishSuccessfullyResponse

    def process_message(message)
      message.destroy!
    end
  end
end
