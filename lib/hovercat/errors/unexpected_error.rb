# frozen_string_literal: true

module Hovercat
  module Errors
    class UnexpectedError < StandardError
      def initialize(msg)
        super
      end
    end
  end
end
