# frozen_string_literal: true

require 'hovercat/constants'
require 'yaml'
require 'hovercat/errors/missing_configuration_file_error'

module Hovercat
  module Helpers
    class Configuration
      attr_reader :configuration

      def initialize
        @configuration = load_config
        validate_config!
      end

      private

      def load_config
        if File.exist?(Constants::REDIS_CONFIGURATION_FILE)
          YAML.load(ERB.new(File.read(Constants::REDIS_CONFIGURATION_FILE)).result)[environment]
        elsif File.exist?(Constants::MEMORY_CONFIGURATION_FILE)
          YAML.load(ERB.new(File.read(Constants::MEMORY_CONFIGURATION_FILE)).result)[environment]
        end
      end

      def environment
        ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'test'
      end

      def validate_config!
        raise Hovercat::Errors::MissingConfigurationFileError, 'Missing hovercat configuration' if @configuration.nil?
      end
    end
  end
end
