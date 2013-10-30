module Ayl

  class ObjectSelectorMessage < Message

    attr_reader :object, :selector, :arguments

    def initialize(obj, sel, opts, *args)
      super :ayl, opts
      
      @object = obj
      @selector = sel
      @arguments = args
    end

    def to_rrepr
      @code ||= %Q{#{object.to_rrepr}.#{selector}(#{arguments.to_rrepr[1...-1]})}
    end

    def to_hash
      @message_hash ||= {
        :type => message_type,
        :failed_job_handler => options.failed_job_handler,
        :code => to_rrepr
      }
    end

    def evaluate(top_binding)
      code_to_eval = to_rrepr
      eval(code_to_eval, top_binding, code_to_eval, 1)
    end

  end

end
