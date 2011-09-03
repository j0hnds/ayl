module Ayl

  module Extensions

    def ayl_send(selector, *args)
      ayl_send_opts(selector, {}, *args)
    end

    def ayl_send_opts(selector, opts, *args)
      message = Message.new(self, selector, MessageOptions.new(opts), *args)
      message.submit
    end

    def rrepr()
      method = (respond_to? :get_cache) ? 'get_cache' : 'find'
      "#{self.class.rrepr}.#{method}(#{id.rrepr})"
    end

  end

end

class Symbol
  def rrepr() inspect end
end

class Module
  def rrepr() name end
end

class NilClass
  def rrepr() inspect end
end

class FalseClass
  def rrepr() inspect end
end

class TrueClass
  def rrepr() inspect end
end

class Numeric
  def rrepr() inspect end
end

class String
  def rrepr() inspect end
end

class Array
  def rrepr() '[' + map(&:rrepr).join(', ') + ']' end
end

class Hash
  def rrepr() '{' + map{|k,v| k.rrepr + '=>' + v.rrepr}.join(', ') + '}' end
end

class Range
  def rrepr() "(#{first.rrepr}#{exclude_end? ? '...' : '..'}#{last.rrepr})" end
end

class Time
  def rrepr() "Time.parse('#{self.inspect}')" end
end

class Date
  def rrepr() "Date.parse('#{self.inspect}')" end
end
