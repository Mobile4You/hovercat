module Hovercat
  class PublishSuccessfullyResponse

    def process_message(message)
      message.destroy!
    end

    def ok?
      true
    end
  end
end
