module Hovercat
  class Publisher
    def publish(params)

    end

    def republish(params)
      response = HoverCat::RepublishFailureResponse.new
      if publish(params)
        response = HoverCat::RepublishSuccessfullyResponse.new
      end
      response
    end
  end
end