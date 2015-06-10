module Ayl

  class Message

    attr_accessor :object, :selector, :options, :arguments
    attr_reader :code

    def initialize(object, selector, opts, *args)
      @object = object
      @selector = selector
      @options = opts
      @arguments = args
    end

    def self.from_hash(message_hash)
      raise Ayl::UnrecoverableMessageException, "parameter must be a hash" unless message_hash.is_a?(Hash)
      raise Ayl::UnrecoverableMessageException, "not a valid message hash" if message_hash[:type] != :ayl || message_hash[:code].nil?
      raise Ayl::UnrecoverableMessageException, "No code provided in job: #{job.body}" if message_hash[:code].nil?

      code = message_hash[:code]

      Message.new(nil, nil, MessageOptions.new).tap do | m |
        m.send(:message_hash=, message_hash)
        m.send(:code=, code)
        m.options.failed_job_handler = message_hash[:failed_job_handler] if message_hash[:failed_job_handler]
        m.options.failed_job_count = message_hash[:failed_job_count] if message_hash[:failed_job_handler] == 'decay' && message_hash[:failed_job_count]
        m.options.failed_job_delay = message_hash[:failed_job_delay] if message_hash[:failed_job_handler] == 'decay' && message_hash[:failed_job_delay]
      end
      
    end

    def to_rrepr
      @code ||= %Q{#{@object.to_rrepr}.#{@selector}(#{@arguments.to_rrepr[1...-1]})}
    end

    def to_hash
      @message_hash ||= new_message_hash
    end

    def new_message_hash
      {
        :type => :ayl,
        :failed_job_handler => options.failed_job_handler,
        :code => to_rrepr
      }.tap do | h |
        if options.failed_job_handler == 'decay'
          h[:failed_job_count] = options.failed_job_count
          h[:failed_job_delay] = options.failed_job_delay
        end
      end
    end

    def evaluate(top_binding)
      code_to_eval = to_rrepr
      eval(code_to_eval, top_binding, code_to_eval, 1)
    end

    private
    
    attr_writer :message_hash, :code
  end

end
