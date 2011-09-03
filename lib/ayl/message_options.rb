module Ayl

  class MessageOptions

    OPTIONS = [ :pri, :fuzz, :delay, :ttr, :queue_name ]

    attr_accessor *OPTIONS

    class << self
      attr_accessor :default_pri, :default_fuzz, :default_delay, :default_ttr, :default_queue_name
    end

    # Set the default options
    self.default_pri = 512
    self.default_fuzz = 0
    self.default_delay = 0
    self.default_ttr = 120
    self.default_queue_name = 'default'

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
