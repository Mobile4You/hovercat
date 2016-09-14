module Hovercat
  class RepublishSuccessfullyResponse

    def process_message(message)
      message.destroy!
    end

    def ok?
      true
    end
  end
end
