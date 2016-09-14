module Hovercat
  class Publisher
    def initialize(connector = Hovercat::BunnyConnector.new)
      @connector = connector
    end

    def publish(params)
      result = true

      begin
        @connector.publish(params)
      rescue Hovercat::UnexpectedError
        result = false
      end

      result
    end
  end
end