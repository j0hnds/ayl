module Ayl

  class Message

    attr_accessor :object, :selector, :options, :arguments

    def initialize(object, selector, opts, *args)
      @object = object
      @selector = selector
      @options = opts
      @arguments = args
    end

    def to_rrepr
      @code ||= %Q{#{@object.to_rrepr}.#{@selector}(#{@arguments.to_rrepr[1...-1]})}
    end

  end

end
