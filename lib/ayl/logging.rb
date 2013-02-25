module Ayl
  module Logging

    def logger() Logger.instance end

    def log_call(method)
      logger.debug "#{self.class.name} invoking #{method}"
      yield
    ensure
      logger.debug "#{self.class.name} done invoking #{method}"
    end

  end
end
