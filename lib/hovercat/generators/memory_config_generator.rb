# frozen_string_literal: true

module Hovercat
  module Generators
    class MemoryConfigGenerator < Thor::Group
      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__)
      end

      def create_memory_config
        template 'templates/hovercat_memory.yml.erb', 'config/hovercat_redis.yml'
      end
    end
  end
end
