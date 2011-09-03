require 'singleton'

module Ayl

  class Engine
    include Singleton

    class << self
      attr_accessor :engines
    end

    def self.get_active_engine
      self.engines ||= []
      engine = self.engines.detect { |engine| engine.is_connected? }
      engine ||= self.instance
    end

    def self.add_engine(engine)
      raise "engine must respond to asynchronous?" unless engine.respond_to?(:asynchronous?)
      raise "engine must respond to is_connected?" unless engine.respond_to?(:is_connected?)
      self.engines ||= []
      self.engines << engine
    end

    def self.clear_engines
      self.engines = []
    end

    # These methods define the API that must be implemented
    # by all engines
    def asynchronous?() false end
    def is_connected?() true end

    def submit(message)
      eval(message.to_rrepr)
    end

    def process_messages
      raise "asynchronous engine cannot receive messages" unless asynchronous?
    end
  end

end
