require 'singleton'

module Ayl

  class Logger
    include Singleton

    attr_accessor :logger

    LOG_METHODS = [ :debug, :error, :fatal, :info, :warn ]

    LOG_METHODS.each do |method|
      define_method(method) do |message|
        if logger
          logger.send(method, message)
        else
          Kernel.puts "#{method.upcase}: #{message}"
        end
      end
    end

  end

end
