module Ayl

  class MessageOptions

    OPTIONS = [ :priority, :fuzz, :delay, :time_to_run, :queue_name, :decay_failed_job ]

    attr_accessor *OPTIONS

    class << self
      attr_accessor :default_priority, :default_fuzz, :default_delay, :default_time_to_run, :default_queue_name, :default_decay_failed_job
    end

    # Set the default options
    self.default_priority = 512
    self.default_fuzz = 0
    self.default_delay = 0
    self.default_time_to_run = 120
    self.default_queue_name = 'default'
    self.default_decay_failed_job = false

    def initialize(opts=nil)
      opts ||= {}
      raise "parameter must be a hash" unless opts.is_a?(Hash)
      unknown_options = opts.keys - OPTIONS
      raise "unknown options specified: #{unknown_options}" unless unknown_options.empty?
      OPTIONS.each do |o|
        send("#{o}=".to_sym, opts.fetch(o, self.class.send("default_#{o}".to_sym)))
      end
    end

  end

end
