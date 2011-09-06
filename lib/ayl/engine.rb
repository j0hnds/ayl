require 'singleton'

module Ayl

  class Engine
    include Singleton

    class << self

      def get_active_engine
        self.engines ||= []
        engine = self.engines.detect { |engine| engine.is_connected? }
        engine ||= self.instance
      end

      def add_engine(engine)
        raise "engine must respond to asynchronous?" unless engine.respond_to?(:asynchronous?)
        raise "engine must respond to is_connected?" unless engine.respond_to?(:is_connected?)
        self.engines << engine
      end

      def clear_engines
        @engines = []
      end

      def engines
        @engines ||= []
      end

    end

    def logger() Logger.instance end

    def log_call(method)
      logger.info "#{self.class.name} invoking #{method}"
      yield
    ensure
      logger.info "#{self.class.name} done invoking #{method}"
    end

    # These methods define the API that must be implemented
    # by all engines
    def asynchronous?() false end
    def is_connected?() true end

    def submit(message)
      log_call(:submit) { eval(message.to_rrepr) }
    end

    def process_messages
      logger.error "Attempt to invoke #{self.class.name}.process_messages failed"
      raise "asynchronous engine cannot receive messages" unless asynchronous?
    end
  end

end
