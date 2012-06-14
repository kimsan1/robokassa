module Robokassa
  mattr_accessor :interface

  class Engine < Rails::Engine #:nodoc:
    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
    end

    config.to_prepare &method(:activate).to_proc
  end
end
