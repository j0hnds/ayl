module Ayl

  class Worker
    include Ayl::Logging

    attr_accessor :eval_binding

    def process_messages
      logger.error "Attempt to invoke #{self.class.name}.process_messages failed"
      raise "synchronous worker cannot receive messages"
    end

    def process_message(message)
      message.evaluate(@eval_binding)
    end
    
  end

end
