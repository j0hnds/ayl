module Ayl

  module Extensions

    def ayl_send(selector, *args)
      ayl_send_opts(selector, {}, *args)
    end

    def ayl_send_opts(selector, opts, *args)
      engine = Ayl::Engine.get_active_engine
      message = Message.new(self, selector, MessageOptions.new(opts), *args)
      engine.submit(message)
    end

  end

  module InstanceExtensions
    def to_rrepr()
      method = (respond_to? :get_cache) ? 'get_cache' : 'find'
      "#{self.class.to_rrepr}.#{method}(#{id.to_rrepr})"
    end
  end

end

[ Array, Hash, Module, Numeric, Range, String, Symbol ].each { |c| c.send :include, Ayl::Extensions }

class Symbol
  def to_rrepr() inspect end
end

class Module
  def to_rrepr() name end
end

class NilClass
  def to_rrepr() inspect end
end

class FalseClass
  def to_rrepr() inspect end
end

class TrueClass
  def to_rrepr() inspect end
end

class Numeric
  def to_rrepr() inspect end
end

class String
  def to_rrepr() inspect end
end

class Array
  def to_rrepr() '[' + map(&:to_rrepr).join(', ') + ']' end
end

class Hash
  def to_rrepr() '{' + map{|k,v| k.to_rrepr + '=>' + v.to_rrepr}.join(', ') + '}' end
end

class Range
  def to_rrepr() "(#{first.to_rrepr}#{exclude_end? ? '...' : '..'}#{last.to_rrepr})" end
end

class Time
  def to_rrepr() "Time.parse('#{self.inspect}')" end
end

class Date
  def to_rrepr() "Date.parse('#{self.inspect}')" end
end
