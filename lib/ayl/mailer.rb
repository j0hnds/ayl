module Ayl

  class Mailer
    include Singleton

    attr_reader :mailer

    def mailer=(mailer)
      raise "Mailer implement the 'ayl_message(message, exception)' method" if mailer && !mailer.respond_to?(:ayl_message)
      @mailer = mailer
    end

    def deliver_message(message, exception=nil)
      mailer.ayl_message(message, exception).deliver if mailer && mailer.respond_to?(:ayl_message)
    rescue Exception => ex
      Ayl::Logger.instance.error("Error sending ayl email message: #{ex.backtrace.join("\n")}")
    end

  end

end
