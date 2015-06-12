require 'spec_helper'

describe Ayl::Message do

  before(:each) do
    # Need to reset the default message options each time
    Ayl::MessageOptions.default_priority = 512
    Ayl::MessageOptions.default_fuzz = 0
    Ayl::MessageOptions.default_delay = 0
    Ayl::MessageOptions.default_time_to_run = 120
    Ayl::MessageOptions.default_queue_name = 'default'
    Ayl::MessageOptions.default_failed_job_handler = 'decay'
    Ayl::MessageOptions.default_failed_job_count = 3 
    Ayl::MessageOptions.default_failed_job_delay = 60 
  end

  context "Initialization" do

    it "should accept an object, selector options and a set of arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      
      expect(m.object).to eq "object"
      expect(m.selector).to eq :method_name
      expect(m.options).to eq options
      expect(m.arguments).to eq [ "arg1", "arg2" ]
    end

    it "should accept an object, selector options and no arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options)
      
      expect(m.object).to eq "object"
      expect(m.selector).to eq :method_name
      expect(m.options).to eq options
      expect(m.arguments).to eq [ ]
    end

  end

  context "Code generation" do
    
    it "should generate code when arguments are present" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      expect(m.to_rrepr).to eq "\"object\".method_name(\"arg1\", \"arg2\")"
    end

    it "should generate code when no arguments are present" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options)
      expect(m.to_rrepr).to eq "\"object\".method_name()"
    end

  end

  context "Message Packaging" do
    
    it "should package up the message into a hash" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      expect(m.to_hash).to eq({ :type => :ayl, :failed_job_handler => 'decay', :failed_job_count => 3, :failed_job_delay => 60, :code => "\"object\".method_name(\"arg1\", \"arg2\")" })
    end

    it "should package up the message into a hash but not with decay" do
      options = Ayl::MessageOptions.new({failed_job_handler: 'delete'})
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      expect(m.to_hash).to eq({ :type => :ayl, :failed_job_handler => 'delete', :code => "\"object\".method_name(\"arg1\", \"arg2\")" })
    end

    it "should package up the message into a hash when the decay failed job has been set" do
      options = Ayl::MessageOptions.new
      options.failed_job_handler = 'decay'
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      expect(m.to_hash).to eq({ :type => :ayl, :failed_job_handler => 'decay', :failed_job_count => 3, :failed_job_delay => 60, :code => "\"object\".method_name(\"arg1\", \"arg2\")" })
    end

    it "should be able to create a message from a hash with code that has arguments" do
      m_hash = { 'type' => 'ayl', 'code' => "\"object\".method_name(\"arg1\", \"arg2\")" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to eq m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments" do
      m_hash = { 'type' => 'ayl', 'code' => "\"object\".method_name()" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to eq m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments and no parens" do
      m_hash = { 'type' => 'ayl', 'code' => "\"object\".method_name" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to eq m_hash
    end

    it "should be able to create a message from a hash with code that has one arguments with multiple parens" do
      m_hash = { 'type' => 'ayl', 'code' => "\"object\".method_name('string'.length())" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to be m_hash
    end

    # Sample._ayl_after_create(Sample.find(106))
    it "should be able to create a message from a hash with code that has one arguments with multiple parens" do
      m_hash = { 'type' => 'ayl', 'code' => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to be m_hash
    end

    it "should create a message with decay_failed job set to false if not in the original hash" do
      Ayl::MessageOptions.default_failed_job_handler = 'delete'
      m_hash = { 'type' => 'ayl', 'code' => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to be m_hash
      expect(m.options.failed_job_handler).to eq 'delete'
    end

    it "should create a message with decay_failed job set to false if in the original hash as false" do
      m_hash = { 'type' => 'ayl', 'failed_job_handler' => 'delete', 'code' => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to be m_hash
      expect(m.options.failed_job_handler).to eq 'delete'
    end

    it "should create a message with decay_failed job set to true if in the original hash as true" do
      m_hash = { 'type' => 'ayl', 'failed_job_handler' => 'decay', 'code' => "String._ayl_after_create(2.to_s(2))" }
      m = Ayl::Message.from_hash(m_hash)
      expect(m.options.is_a?(Ayl::MessageOptions)).to be true
      expect(m.to_hash).to be m_hash
      expect(m.options.failed_job_handler).to eq 'decay'
    end


  end

  context "Code Evaluation" do
    
    it "should evaluate the code associated with the message" do
      array_of_nums = [ 3, 2, 8, 1 ]
      m = Ayl::Message.new(array_of_nums, :length, Ayl::MessageOptions.new)
      expect(m.evaluate(binding)).to be 4
    end

  end

end
