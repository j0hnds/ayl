module Ayl

  class MessageOptions

    OPTIONS = [ 
      :priority, 
      :fuzz, 
      :delay, 
      :time_to_run, 
      :queue_name, 
      :failed_job_handler,
      :failed_job_delay,
      :failed_job_count ]

    VALID_FAILED_JOB_HANDLERS = %W{ bury decay delete }

    attr_accessor *OPTIONS

    class << self
      attr_accessor :default_priority, :default_fuzz, :default_delay, :default_time_to_run, :default_queue_name 
      attr_accessor :default_failed_job_handler, :default_failed_job_delay, :default_failed_job_count 
    end

    # Set the default options
    self.default_priority = 512
    self.default_fuzz = 0
    self.default_delay = 0
    self.default_time_to_run = 120
    self.default_queue_name = 'default'
    self.default_failed_job_handler = 'delete'
    self.default_failed_job_delay = 60
    self.default_failed_job_count = 3

    def initialize(opts=nil)
      opts ||= {}
      raise "parameter must be a hash" unless opts.is_a?(Hash)
      unknown_options = opts.keys - OPTIONS
      raise "unknown options specified: #{unknown_options}" unless unknown_options.empty?
      OPTIONS.each do |o|
        if o == :failed_job_handler
          if !(v = opts[o]).nil?
            raise "value for :failed_job_handler must be one of: #{VALID_FAILED_JOB_HANDLERS.join(', ')}" unless VALID_FAILED_JOB_HANDLERS.include?(v)
          end
        end
        send("#{o}=".to_sym, opts.fetch(o, self.class.send("default_#{o}".to_sym)))
      end
    end

  end

end
