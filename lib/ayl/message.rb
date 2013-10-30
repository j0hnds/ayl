module Ayl

  class Message

    attr_reader :message_type, :options

    def initialize(msg_type, opts)
      @message_type = msg_type
      @options = opts
    end

    def self.from_hash(message_hash)
      raise Ayl::UnrecoverableMessageException, "parameter must be a hash" unless message_hash.is_a?(Hash)
      raise Ayl::UnrecoverableMessageException, "not a valid message hash" unless [ :ayl, :lambda ].include?(message_hash[:type])
      raise Ayl::UnrecoverableMessageException, "No code provided in job: #{job.body}" if message_hash[:code].nil?

      code = message_hash[:code]

      case message_hash[:type]
      when :ayl
        ObjectSelectorMessage.new(nil, nil, MessageOptions.new).tap do | m |
          m.send(:message_hash=, message_hash)
          m.send(:code=, code)
          m.options.failed_job_handler = message_hash[:failed_job_handler] if message_hash[:failed_job_handler]
        end
      when :lambda
        LambdaMessage.new(message_hash[:code],
                          MessageOptions.new,
                          *(message_hash[:arguments])).tap do | m |
          m.send(:args_converted=, false)
        end
      end
      
    end

    private
    
    attr_writer :message_hash, :code

  end

end
