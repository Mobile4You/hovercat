module Hovercat
  require 'bunny'

  class Engine < ::Rails::Engine
    isolate_namespace Hovercat
  end
end
