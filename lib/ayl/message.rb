module Ayl

  class Message

    attr_accessor :object, :selector, :options, :arguments

    def initialize(object, selector, opts, *args)
      @object = object
      @selector = selector
      @options = opts
      @arguments = args
    end

    def submit
      engine = Ayl::Engine.get_active_engine

      engine.put rrepr, @options
    end

    def rrepr
      @code ||= %Q{#{@object.rrepr}.#{@selector}(#{@arguments.rrepr[1...-1]})}
    end

  end

end
