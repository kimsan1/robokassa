require 'cgi'
require 'digest/md5'

module Robokassa
  class InvalidSignature < ArgumentError; end
  class InvalidToken < ArgumentError; end

  autoload :Interface, 'robokassa/interface.rb'
  autoload :Controller, 'robokassa/controller.rb'

  mattr_accessor :interface

  class Engine < Rails::Engine #:nodoc:
    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
    end

    config.to_prepare &method(:activate).to_proc
  end
end
