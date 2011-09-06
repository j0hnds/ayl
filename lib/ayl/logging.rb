module Ayl
  module Logging

    def logger() Logger.instance end

    def log_call(method)
      logger.info "#{self.class.name} invoking #{method}"
      yield
    ensure
      logger.info "#{self.class.name} done invoking #{method}"
    end

  end
end
