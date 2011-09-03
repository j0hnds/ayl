require 'singleton'

module Ayl

  class Engine
    include Singleton

    def self.get_active_engine
      self.instance
    end

    # These methods define the API that must be implemented
    # by all engines
    def asynchronous?() false end
    def is_connected?() true end

    def submit(message)
      eval(message.to_rrepr)
    end
  end

end
