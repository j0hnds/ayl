require 'spec_helper'

describe Ayl::LambdaMessage do

  before(:each) do
    # Need to reset the default message options each time
    Ayl::MessageOptions.default_priority = 512
    Ayl::MessageOptions.default_fuzz = 0
    Ayl::MessageOptions.default_delay = 0
    Ayl::MessageOptions.default_time_to_run = 120
    Ayl::MessageOptions.default_queue_name = 'default'
    Ayl::MessageOptions.default_failed_job_handler = 'decay'
  end

  after(:each) do
    Ayl::MessageOptions.default_failed_job_handler = 'delete'
  end

  context "Initialization" do

    it "should accept lambda code options and a set of arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::LambdaMessage.new("->(value1, value2) { value1 + value2 * 10 }", 
                                 options, 
                                 1, 2)
      
      m.code.should == "->(value1, value2) { value1 + value2 * 10 }"
      m.options.should == options
      m.arguments.should == [ 1, 2 ]
      m.args_converted.should be_true
    end

    it "should accept lambda code options and no arguments" do
      options = Ayl::MessageOptions.new

      m = Ayl::LambdaMessage.new("->(value1, value2) { value1 + value2 * 10 }", 
                                 options)
      
      m.code.should == "->(value1, value2) { value1 + value2 * 10 }"
      m.options.should == options
      m.arguments.should == [ ]
      m.args_converted.should be_true
    end

  end

  context "Message Packaging" do
    
    it "should package up the message into a hash" do
      options = Ayl::MessageOptions.new
      m = Ayl::LambdaMessage.new("->(value1, value2) { value1 + value2 * 10 }", 
                                 options, 
                                 1, 2)
      m.to_hash.should == { 
        :type => :lambda, 
        :failed_job_handler => 'decay', 
        :code => "->(value1, value2) { value1 + value2 * 10 }",
        :arguments => [ "1", "2" ] 
      }
    end

    it "should package up the message into a hash when the decay failed job has been set" do
      options = Ayl::MessageOptions.new
      options.failed_job_handler = 'decay'
      m = Ayl::LambdaMessage.new("->(value1, value2) { value1 + value2 * 10 }", 
                                 options, 
                                 1, 2)
      m.to_hash.should == { 
        :type => :lambda, 
        :failed_job_handler => 'decay', 
        :code => "->(value1, value2) { value1 + value2 * 10 }",
        :arguments => [ "1", "2" ] 
      }
    end

    it "should be able to create a message from a hash with code that has arguments" do
      m_hash = { 
        :type => :lambda, 
        :failed_job_handler => 'decay', 
        :code => "->(value1, value2) { value1 + value2 * 10 }",
        :arguments => [ "1", "2" ]
      }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::LambdaMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments" do
      m_hash = { 
        :type => :lambda, 
        :failed_job_handler => 'decay', 
        :code => "->(value1, value2) { value1 + value2 * 10 }",
        :arguments => []
      }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::LambdaMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    it "should create a message with decay_failed job set to false if not in the original hash" do
      Ayl::MessageOptions.default_failed_job_handler = 'delete'
      m_hash = { 
        :type => :lambda, 
        :failed_job_handler => 'delete', 
        :code => "->(value1, value2) { value1 + value2 * 10 }",
        :arguments => []
      }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::LambdaMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
      m.options.failed_job_handler.should == 'delete'
    end


  end

  context "Code Evaluation" do
    
    it "should evaluate the code associated with the message" do
      m = Ayl::LambdaMessage.new("->(value1, value2) { value1 + value2 * 10 }", 
                                 Ayl::MessageOptions.new, 
                                 1, 2)
      m.evaluate(binding).should == 21
    end

    it "should evaluate the code associated with the message converted from a hash" do
      m_hash = { 
        :type => :lambda, 
        :failed_job_handler => 'decay', 
        :code => "->(value1, value2) { value1 + value2 * 10 }",
        :arguments => [ "1", "2" ]
      }
      m = Ayl::Message.from_hash(m_hash)

      m.evaluate(binding).should == 21
    end

  end

end
