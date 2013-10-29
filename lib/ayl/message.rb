module Ayl

  class Message

    attr_accessor :object, :selector, :options, :arguments

    # Don't want anyone else constructing a message object
    # other than the class methods
    private_class_method :new

    def initialize(object, selector, opts, *args)
      @object = object
      @selector = selector
      @options = opts
      @arguments = args
    end

    def self.from_object_selector(object, selector, opts, *args)
      Message.send(:new, object, selector, opts, *args)
    end

    def self.from_hash(message_hash)
      raise Ayl::UnrecoverableMessageException, "parameter must be a hash" unless message_hash.is_a?(Hash)
      raise Ayl::UnrecoverableMessageException, "not a valid message hash" if message_hash[:type] != :ayl || message_hash[:code].nil?
      raise Ayl::UnrecoverableMessageException, "No code provided in job: #{job.body}" if message_hash[:code].nil?

      code = message_hash[:code]

      Message.send(:new, nil, nil, MessageOptions.new).tap do | m |
        m.send(:message_hash=, message_hash)
        m.send(:code=, code)
        m.options.failed_job_handler = message_hash[:failed_job_handler] if message_hash[:failed_job_handler]
      end
      
    end

    def to_rrepr
      @code ||= %Q{#{@object.to_rrepr}.#{@selector}(#{@arguments.to_rrepr[1...-1]})}
    end

    def to_hash
      @message_hash ||= {
        :type => :ayl,
        :failed_job_handler => options.failed_job_handler,
        :code => to_rrepr
      }
    end

    def evaluate(top_binding)
      code_to_eval = to_rrepr
      eval(code_to_eval, top_binding, code_to_eval, 1)
    end

    private
    
    attr_writer :message_hash, :code

  end

end
