module Hovercat
  class Publisher
    def publish(params)
    end

    def republish(params)
      response = Hovercat::RepublishFailureResponse.new
      if publish(params)
        response = Hovercat::RepublishSuccessfullyResponse.new
      end
      response
    end
  end
end