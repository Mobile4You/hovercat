# frozen_string_literal: true

module Hovercat
  module Models
    class PublishSuccessfullyResponse
      def process_message(_message); end

      def ok?
        true
      end
    end
  end
end
