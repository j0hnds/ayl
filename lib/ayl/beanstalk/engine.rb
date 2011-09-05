module Ayl

  module Beanstalk

    class Engine

      def initialize(host='localhost', port=11300)
        @host = host
        @port = port
      end

      def asynchronous?() true end

      def is_connected?
        connected = true
        begin
          pool
        rescue ::Beanstalk::NotConnected
          connected = false
        end
        connected
      end

      def submit(message)
        pool.use(message.options.queue_name)

        pool.put({ :type => :ayl, :code => message.to_rrepr }.to_yaml)
      end

      def process_messages
        pool.watch(Ayl::MessageOptions.default_queue_name)
        while true
          job = pool.reserve
          process_message(job)
          job.delete
        end
      end

      private

      def pool
        @pool ||= ::Beanstalk::Pool.new([ "#{@host}:#{@port}" ])
      end

      def process_message(job)
        begin
          h = YAML::load(job.body)
          raise "Body of job expected to be a hash: #{job.body}" unless h.is_a?(Hash)
          raise "Unknown type of job: #{h.inspect}" unless h[:type] == :ayl # Not our kind of job
          raise "No code provided in job: #{job.body}" if h[:code].nil?
          eval(h[:code])
        rescue Exception => ex
          raise "Exception in process_messages: #{ex}"
        end
      end

    end

    
  end

end
