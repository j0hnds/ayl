module Ayl

  class Message

    attr_accessor :object, :selector, :options, :arguments

    def initialize(object, selector, opts, *args)
      @object = object
      @selector = selector
      @options = opts
      @arguments = args
    end

    def self.from_hash(message_hash)
      raise "parameter must be a hash" unless message_hash.is_a?(Hash)
      raise "not a valid message hash" if message_hash[:type] != :ayl || message_hash[:code].nil?
      code = message_hash[:code]
      dot_index = code.index('.')
      arguments = []
      if dot_index
        object_code = code[0...dot_index]
        lparen_index = code.index('(')
        if lparen_index
          method_code = code[dot_index+1...lparen_index]
          rparen_index = code.index(')')
          if rparen_index
            argument_list = code[lparen_index+1...rparen_index].split(',')
            arguments = argument_list.collect { | arg | eval(arg) }
          else
            raise "malformed expression"
          end
        else
          # No lparen, just eval the whole thing and set that
          # as the selector
          method_code = code[dot_index+1..-1]
        end
        selector = method_code.to_sym
      else
        # No dot; just eval the whole thing and set that as the
        # object
        object_code = code
      end
      object = eval(object_code)

      Message.new(object, selector, MessageOptions.new, *arguments).tap do | m |
        m.send(:message_hash=, message_hash)
        m.send(:code=, code)
      end
      
    end

    def to_rrepr
      @code ||= %Q{#{@object.to_rrepr}.#{@selector}(#{@arguments.to_rrepr[1...-1]})}
    end

    def to_hash
      @message_hash ||= {
        :type => :ayl,
        :code => to_rrepr
      }
    end

    def evaluate
      eval(to_rrepr)
    end

    private
    
    attr_writer :message_hash, :code
  end

end
