module Hovercat
  class Message
    attr_reader :routing_key

    def initialize
      @routing_key = ''
    end

    def to_json
      ''
    end
  end
end
