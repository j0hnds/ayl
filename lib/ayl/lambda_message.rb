module Ayl

  class LambdaMessage < Message

    attr_reader :code, :arguments, :args_converted

    def initialize(lambda_code, opts, *args)
      super :lambda, opts

      @code = lambda_code
      @arguments = args || []
      @args_converted = true
    end

    def to_hash
      @message_hash ||= {
        :type => message_type,
        :failed_job_handler => options.failed_job_handler,
        :code => code,
        :arguments => args_converted ? arguments.map { | arg | arg.to_rrepr } : arguments
      }
    end

    def evaluate(top_binding)
      the_lambda = eval(code)
      the_lambda.call *(args_converted ? arguments : arguments.map { | arg | eval(arg) })
    end

    def to_rrepr
      code
    end

    private 

    attr_writer :args_converted

  end

end
