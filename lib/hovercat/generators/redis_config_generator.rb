# frozen_string_literal: true

module Hovercat
  module Generators
    class RedisConfigGenerator < Thor::Group
      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__)
      end

      def create_redis_config
        template 'templates/hovercat_redis_storage.yml.erb', 'config/hovercat_redis_storage.yml'
      end
    end
  end
end
