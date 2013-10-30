require 'spec_helper'

describe Ayl::ObjectSelectorMessage do

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

    it "should accept an object, selector options and a set of arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::ObjectSelectorMessage.new("object", 
                                         :method_name, 
                                         options, 
                                         "arg1", "arg2")
      
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.should == options
      m.arguments.should == [ "arg1", "arg2" ]
    end

    it "should accept an object, selector options and no arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::ObjectSelectorMessage.new("object", :method_name, options)
      
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.should == options
      m.arguments.should == [ ]
    end

  end

  context "Code generation" do
    
    it "should generate code when arguments are present" do
      options = Ayl::MessageOptions.new
      m = Ayl::ObjectSelectorMessage.new("object", 
                                         :method_name, 
                                         options, 
                                         "arg1", 
                                         "arg2")
      m.to_rrepr.should == "\"object\".method_name(\"arg1\", \"arg2\")"
    end

    it "should generate code when no arguments are present" do
      options = Ayl::MessageOptions.new
      m = Ayl::ObjectSelectorMessage.new("object", :method_name, options)
      m.to_rrepr.should == "\"object\".method_name()"
    end

  end

  context "Message Packaging" do
    
    it "should package up the message into a hash" do
      options = Ayl::MessageOptions.new
      m = Ayl::ObjectSelectorMessage.new("object", 
                                         :method_name, 
                                         options, 
                                         "arg1", 
                                         "arg2")
      m.to_hash.should == { 
        :type => :ayl, 
        :failed_job_handler => 'decay', 
        :code => "\"object\".method_name(\"arg1\", \"arg2\")" }
    end

    it "should package up the message into a hash when the decay failed job has been set" do
      options = Ayl::MessageOptions.new
      options.failed_job_handler = 'decay'
      m = Ayl::ObjectSelectorMessage.new("object", 
                                         :method_name, 
                                         options, 
                                         "arg1", 
                                         "arg2")
      m.to_hash.should == { 
        :type => :ayl, 
        :failed_job_handler => 'decay', 
        :code => "\"object\".method_name(\"arg1\", \"arg2\")" }
    end

    it "should be able to create a message from a hash with code that has arguments" do
      m_hash = { 
        :type => :ayl, 
        :code => "\"object\".method_name(\"arg1\", \"arg2\")" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments" do
      m_hash = { 
        :type => :ayl, 
        :code => "\"object\".method_name()" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments and no parens" do
      m_hash = { 
        :type => :ayl, 
        :code => "\"object\".method_name" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has one arguments with multiple parens" do
      m_hash = { 
        :type => :ayl, 
        :code => "\"object\".method_name('string'.length())" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    # Sample._ayl_after_create(Sample.find(106))
    it "should be able to create a message from a hash with code that has one arguments with multiple parens" do
      m_hash = { 
        :type => :ayl, 
        :code => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
    end

    it "should create a message with decay_failed job set to false if not in the original hash" do
      Ayl::MessageOptions.default_failed_job_handler = 'delete'
      m_hash = { 
        :type => :ayl, 
        :code => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
      m.options.failed_job_handler.should == 'delete'
    end

    it "should create a message with decay_failed job set to false if in the original hash as false" do
      m_hash = { 
        :type => :ayl, 
        :failed_job_handler => 'delete', 
        :code => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
      m.options.failed_job_handler.should == 'delete'
    end

    it "should create a message with decay_failed job set to true if in the original hash as true" do
      m_hash = { 
        :type => :ayl, 
        :failed_job_handler => 'decay',
        :code => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      m.is_a?(Ayl::ObjectSelectorMessage).should be_true
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.to_hash.should === m_hash
      m.options.failed_job_handler.should == 'decay'
    end


  end

  context "Code Evaluation" do
    
    it "should evaluate the code associated with the message" do
      array_of_nums = [ 3, 2, 8, 1 ]
      m = Ayl::ObjectSelectorMessage.new(array_of_nums, 
                                         :length, 
                                         Ayl::MessageOptions.new)
      m.evaluate(binding).should == 4
    end

  end

end