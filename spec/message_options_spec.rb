require 'spec_helper'

describe Ayl::MessageOptions do

  context "Option Default Accessors" do

    it "should have the correct defaults" do
      expect(Ayl::MessageOptions.default_priority).to eq(512)
      expect(Ayl::MessageOptions.default_fuzz).to eq(0)
      expect(Ayl::MessageOptions.default_delay).to eq(0)
      expect(Ayl::MessageOptions.default_time_to_run).to eq(120)
      expect(Ayl::MessageOptions.default_queue_name).to eq('default')
      expect(Ayl::MessageOptions.default_failed_job_handler).to eq('delete')
      expect(Ayl::MessageOptions.default_failed_job_count).to eq(3)
      expect(Ayl::MessageOptions.default_failed_job_delay).to eq(60)
    end

    it "should reflect the changes if changes have been made" do
      Ayl::MessageOptions.default_priority = 256
      Ayl::MessageOptions.default_fuzz = 18
      Ayl::MessageOptions.default_delay = 2300
      Ayl::MessageOptions.default_time_to_run = 1
      Ayl::MessageOptions.default_queue_name = 'different'
      Ayl::MessageOptions.default_failed_job_handler = 'bury'
      Ayl::MessageOptions.default_failed_job_count = 8
      Ayl::MessageOptions.default_failed_job_delay = 3600

      expect(Ayl::MessageOptions.default_priority).to eq(256)
      expect(Ayl::MessageOptions.default_fuzz).to eq(18)
      expect(Ayl::MessageOptions.default_delay).to eq(2300)
      expect(Ayl::MessageOptions.default_time_to_run).to eq(1)
      expect(Ayl::MessageOptions.default_queue_name).to eq('different')
      expect(Ayl::MessageOptions.default_failed_job_handler).to eq('bury')
      expect(Ayl::MessageOptions.default_failed_job_count).to eq(8)
      expect(Ayl::MessageOptions.default_failed_job_delay).to eq(3600)
    end

  end

  context "Initialization" do

    it "should respond with the correct defaults when initialized with an empty hash" do
      mo = Ayl::MessageOptions.new({})

      expect(mo.priority).to eq(Ayl::MessageOptions.default_priority)
      expect(mo.fuzz).to eq(Ayl::MessageOptions.default_fuzz)
      expect(mo.delay).to eq(Ayl::MessageOptions.default_delay)
      expect(mo.time_to_run).to eq(Ayl::MessageOptions.default_time_to_run)
      expect(mo.queue_name).to eq(Ayl::MessageOptions.default_queue_name)
      expect(mo.failed_job_handler).to eq(Ayl::MessageOptions.default_failed_job_handler)
      expect(mo.failed_job_count).to eq(Ayl::MessageOptions.default_failed_job_count)
      expect(mo.failed_job_delay).to eq(Ayl::MessageOptions.default_failed_job_delay)
    end

    it "should respond with the correct defaults when initialized with nil" do
      mo = Ayl::MessageOptions.new(nil)

      expect(mo.priority).to eq(Ayl::MessageOptions.default_priority)
      expect(mo.fuzz).to eq(Ayl::MessageOptions.default_fuzz)
      expect(mo.delay).to eq(Ayl::MessageOptions.default_delay)
      expect(mo.time_to_run).to eq(Ayl::MessageOptions.default_time_to_run)
      expect(mo.queue_name).to eq(Ayl::MessageOptions.default_queue_name)
      expect(mo.failed_job_handler).to eq(Ayl::MessageOptions.default_failed_job_handler)
      expect(mo.failed_job_count).to eq(Ayl::MessageOptions.default_failed_job_count)
      expect(mo.failed_job_delay).to eq(Ayl::MessageOptions.default_failed_job_delay)
    end

    it "should respond with the correct defaults when initialized with no parameter" do
      mo = Ayl::MessageOptions.new()

      expect(mo.priority).to eq(Ayl::MessageOptions.default_priority)
      expect(mo.fuzz).to eq(Ayl::MessageOptions.default_fuzz)
      expect(mo.delay).to eq(Ayl::MessageOptions.default_delay)
      expect(mo.time_to_run).to eq(Ayl::MessageOptions.default_time_to_run)
      expect(mo.queue_name).to eq(Ayl::MessageOptions.default_queue_name)
      expect(mo.failed_job_handler).to eq(Ayl::MessageOptions.default_failed_job_handler)
      expect(mo.failed_job_count).to eq(Ayl::MessageOptions.default_failed_job_count)
      expect(mo.failed_job_delay).to eq(Ayl::MessageOptions.default_failed_job_delay)
    end

    it "should respond with the correct values when all are specified in the options" do
      opts = { priority: 22, fuzz: 88, delay: 99, time_to_run: 11, queue_name: 'stub', 
        failed_job_handler: 'decay', failed_job_count: 12, failed_job_delay: 14 }
      mo = Ayl::MessageOptions.new(opts)

      expect(mo.priority).to eq(opts[:priority])
      expect(mo.fuzz).to eq(opts[:fuzz])
      expect(mo.delay).to eq(opts[:delay])
      expect(mo.time_to_run).to eq(opts[:time_to_run])
      expect(mo.queue_name).to eq(opts[:queue_name])
      expect(mo.failed_job_handler).to eq(opts[:failed_job_handler])
      expect(mo.failed_job_count).to eq(opts[:failed_job_count])
      expect(mo.failed_job_delay).to eq(opts[:failed_job_delay])
    end

    it "should respond with the correct values when some values are specified in the options" do
      opts = { :priority => 22, :fuzz => 88, :delay => 99 }
      mo = Ayl::MessageOptions.new(opts)

      expect(mo.priority).to eq(opts[:priority])
      expect(mo.fuzz).to eq(opts[:fuzz])
      expect(mo.delay).to eq(opts[:delay])
      expect(mo.time_to_run).to eq(Ayl::MessageOptions.default_time_to_run)
      expect(mo.queue_name).to eq(Ayl::MessageOptions.default_queue_name)
      expect(mo.failed_job_handler).to eq(Ayl::MessageOptions.default_failed_job_handler)
      expect(mo.failed_job_count).to eq(Ayl::MessageOptions.default_failed_job_count)
      expect(mo.failed_job_delay).to eq(Ayl::MessageOptions.default_failed_job_delay)
    end

    it "should raise an exception when an invalid option is provided in the hash" do
      expect { Ayl::MessageOptions.new({:bob => 'something' }) }.to raise_error
    end

    it "should raise an exception when a non-hash is provided as a parameter" do
      expect { Ayl::MessageOptions.new(14) }.to raise_error
    end

  end

end
