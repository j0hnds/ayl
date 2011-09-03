require 'spec_helper'

describe Ayl::MessageOptions do

  context "Option Default Accessors" do

    it "should have the correct defaults" do
      Ayl::MessageOptions.default_priority.should == 512
      Ayl::MessageOptions.default_fuzz.should == 0
      Ayl::MessageOptions.default_delay.should == 0
      Ayl::MessageOptions.default_time_to_run.should == 120
      Ayl::MessageOptions.default_queue_name.should == 'default'
    end

    it "should reflect the changes if changes have been made" do
      Ayl::MessageOptions.default_priority = 256
      Ayl::MessageOptions.default_fuzz = 18
      Ayl::MessageOptions.default_delay = 2300
      Ayl::MessageOptions.default_time_to_run = 1
      Ayl::MessageOptions.default_queue_name = 'different'

      Ayl::MessageOptions.default_priority.should == 256
      Ayl::MessageOptions.default_fuzz.should == 18
      Ayl::MessageOptions.default_delay.should == 2300
      Ayl::MessageOptions.default_time_to_run.should == 1
      Ayl::MessageOptions.default_queue_name.should == 'different'
    end

  end

  context "Initialization" do

    it "should respond with the correct defaults when initialized with an empty hash" do
      mo = Ayl::MessageOptions.new({})

      mo.priority.should == Ayl::MessageOptions.default_priority
      mo.fuzz.should == Ayl::MessageOptions.default_fuzz
      mo.delay.should == Ayl::MessageOptions.default_delay
      mo.time_to_run.should == Ayl::MessageOptions.default_time_to_run
      mo.queue_name.should == Ayl::MessageOptions.default_queue_name
    end

    it "should respond with the correct defaults when initialized with nil" do
      mo = Ayl::MessageOptions.new(nil)

      mo.priority.should == Ayl::MessageOptions.default_priority
      mo.fuzz.should == Ayl::MessageOptions.default_fuzz
      mo.delay.should == Ayl::MessageOptions.default_delay
      mo.time_to_run.should == Ayl::MessageOptions.default_time_to_run
      mo.queue_name.should == Ayl::MessageOptions.default_queue_name
    end

    it "should respond with the correct defaults when initialized with no parameter" do
      mo = Ayl::MessageOptions.new()

      mo.priority.should == Ayl::MessageOptions.default_priority
      mo.fuzz.should == Ayl::MessageOptions.default_fuzz
      mo.delay.should == Ayl::MessageOptions.default_delay
      mo.time_to_run.should == Ayl::MessageOptions.default_time_to_run
      mo.queue_name.should == Ayl::MessageOptions.default_queue_name
    end

    it "should respond with the correct values when all are specified in the options" do
      opts = { :priority => 22, :fuzz => 88, :delay => 99, :time_to_run => 11, :queue_name => 'stub' }
      mo = Ayl::MessageOptions.new(opts)

      mo.priority.should == opts[:priority]
      mo.fuzz.should == opts[:fuzz]
      mo.delay.should == opts[:delay]
      mo.time_to_run.should == opts[:time_to_run]
      mo.queue_name.should == opts[:queue_name]
    end

    it "should respond with the correct values when some values are specified in the options" do
      opts = { :priority => 22, :fuzz => 88, :delay => 99 }
      mo = Ayl::MessageOptions.new(opts)

      mo.priority.should == opts[:priority]
      mo.fuzz.should == opts[:fuzz]
      mo.delay.should == opts[:delay]
      mo.time_to_run.should == Ayl::MessageOptions.default_time_to_run
      mo.queue_name.should == Ayl::MessageOptions.default_queue_name
    end

    it "should raise an exception when an invalid option is provided in the hash" do
      lambda { Ayl::MessageOptions.new({:bob => 'something' }) }.should raise_error
    end

    it "should raise an exception when a non-hash is provided as a parameter" do
      lambda { Ayl::MessageOptions.new(14) }.should raise_error
    end

  end

end
