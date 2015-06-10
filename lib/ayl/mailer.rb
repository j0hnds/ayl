module Ayl

  class Mailer
    include Singleton

    attr_reader :mailer

    def mailer=(mailer)
      raise "Mailer must implement the 'ayl_message(message, exception)' method" if mailer && !mailer.respond_to?(:ayl_message)
      raise "Mailer must implement the 'burying_job(code)' method" if mailer && !mailer.respond_to?(:burying_job)
      @mailer = mailer
    end

    def deliver_message(message, exception=nil)
      mailer.ayl_message(message, exception).deliver if mailer && mailer.respond_to?(:ayl_message)
    rescue Exception => ex
      Ayl::Logger.instance.error("Error sending ayl email message: #{ex.backtrace.join("\n")}")
    end

    def burying_job(code)
      mailer.burying_job(code).deliver if mailer && mailer.respond_to?(:burying_job)
    rescue Exception => ex
      Ayl::Logger.instance.error("Error sending burying_job email message: #{ex.backtrace.join("\n")}")
    end

  end

end
