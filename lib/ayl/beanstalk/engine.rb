module Ayl

  module Beanstalk

    class Engine
      include Ayl::Logging

      def initialize(host='localhost', port=11300)
        logger.info "#{self.class.name}.initialize(#{host.inspect}, #{port})"
        @host = host
        @port = port
        @stop = false
      end

      def asynchronous?() true end

      def is_connected?
        connected = true
        begin
          pool
        rescue ::Beanstalk::NotConnected => ex
          logger.error "#{self.class.name} not connected error: #{ex}"
          connected = false
        end
        connected
      end

      def submit(message)
        log_call(:submit) do
          begin
            pool.use(message.options.queue_name)
            code = message.to_rrepr
            logger.info "#{self.class.name} submitting '#{code}' to tube '#{message.options.queue_name}'"
            pool.yput(message.to_hash, message.options.priority, message.options.delay, message.options.time_to_run)
          rescue Exception => ex
            logger.error "Error submitting message to beanstalk: #{ex}"
          end
        end
      end

      def process_messages
        logger.info "#{self.class.name} entering process_messages loop"
        # trap('TERM') { puts "## Got the term signal"; @stop = true }
        # trap('INT') { puts "## Got the int signal"; @stop = true }
        pool.watch(Ayl::MessageOptions.default_queue_name)
        while true
          break if @stop
          job = pool.reserve
          break if job.nil?
          begin
            process_message(job)
            job.delete
          rescue Ayl::Beanstalk::UnrecoverableJobException => ex
            logger.error "#{self.class.name} Unrecoverable exception in process_messages: #{ex}"
            job.delete
          rescue Exception => ex
            logger.error "#{self.class.name} Exception in process_messages: #{ex}"
            if job.age > 60
              job.delete
            else
              job.decay
            end
          end
        end
      end

      private

      def pool
        @pool ||= ::Beanstalk::Pool.new([ "#{@host}:#{@port}" ])
      end

      def process_message(job)
        puts "Processing the job"
        h = job.ybody
        raise Ayl::Beanstalk::UnrecoverableJobException, "Body of job expected to be a hash: #{job.body}" unless h.is_a?(Hash)
        raise Ayl::Beanstalk::UnrecoverableJobException, "Unknown type of job: #{h.inspect}" unless h[:type] == :ayl # Not our kind of job
        raise Ayl::Beanstalk::UnrecoverableJobException, "No code provided in job: #{job.body}" if h[:code].nil?
        eval(h[:code])
        puts "Done processing the job"
      end

    end

    
  end

end
