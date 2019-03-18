# frozen_string_literal: true

require 'hovercat/constants'
require 'yaml'
require 'hovercat/errors/missing_configuration_file_error'

module Hovercat
  module Helpers
    class Configuration
      attr_reader :configuration

      def initialize
        @configuration = YAML.load_file(Constants::REDIS_CONFIGURATION_FILE) if File.exist?(Constants::REDIS_CONFIGURATION_FILE)
        @configuration = YAML.load_file(Constants::MEMORY_CONFIGURATION_FILE) if File.exist?(Constants::MEMORY_CONFIGURATION_FILE)
        raise Hovercat::Errors::MissingConfigurationFileError, 'Missing hovercat configuration file' if @configuration.nil?
      end
    end
  end
end
