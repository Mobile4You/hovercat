# frozen_string_literal: true

module Hovercat
  module Errors
    class MissingConfigurationFileError < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end
