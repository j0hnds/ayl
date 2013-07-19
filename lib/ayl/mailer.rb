module Ayl

  class Mailer
    include Singleton

    attr_reader :mailer

    def mailer=(mailer)
      raise "Mailer implement the 'ayl_message(message, stack_trace)' method" if mailer && !mailer.respond_to?(:ayl_message)
      @mailer = mailer
    end

    def deliver_message(message, stack_trace=nil)
      mailer.ayl_message(message, stack_trace).deliver if mailer && mailer.respond_to?(:ayl_message)
    end

  end

end
