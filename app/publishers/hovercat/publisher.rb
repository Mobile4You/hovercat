module Hovercat
  class Publisher
    def initialize(connector = Hovercat::BunnyConnector.new)
      @connector = connector
    end

    def publish(params)
      response = Hovercat::PublishSuccessfullyResponse.new

      begin
        @connector.publish(params)
      rescue Hovercat::UnexpectedError
        response = Hovercat::PublishFailureResponse.new
      end

      response
    end
  end
end