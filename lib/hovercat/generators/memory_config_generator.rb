# frozen_string_literal: true

module Hovercat
  module Generators
    class MemoryConfigGenerator < Thor::Group
      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__)
      end

      def create_memory_config
        template 'templates/hovercat_memory_storage.yml.erb', 'config/hovercat_memory_storage.yml'
      end
    end
  end
end
