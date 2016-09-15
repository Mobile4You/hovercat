require 'hovercat/engine'
require 'hovercat/config'

module Hovercat
  CONFIG = Hovercat::Config.new.configs

  def self.config(opts = {})
    CONFIG.merge!(opts.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo })
  end
end
