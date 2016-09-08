require 'hovercat/engine'

module Hovercat
  def self.config(opts = {})
    HoverCat::Config.merge!(opts)
  end
end
