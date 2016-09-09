require 'hovercat/engine'
require 'hovercat/config'

module Hovercat
  CONFIG = HoverCat::Config.new.configs

  def self.config(opts = {})
    CONFIG.merge!(opts)
  end
end
