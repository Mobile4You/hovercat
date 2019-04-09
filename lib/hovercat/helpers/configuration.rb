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
        memory_file_path = Hovercat::Constants::MEMORY_CONFIGURATION_FILE
        redis_file_path = Hovercat::Constants::REDIS_CONFIGURATION_FILE
        whitelist_classes = []
        whitelist_symbols = []
        aliases = true

        if File.exist?(redis_file_path)
          YAML.safe_load(ERB.new(File.read(redis_file_path)).result, whitelist_classes, whitelist_symbols, aliases)[environment]
        elsif File.exist?(memory_file_path)
          YAML.safe_load(ERB.new(File.read(memory_file_path)).result, whitelist_classes, whitelist_symbols, aliases)[environment]
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
