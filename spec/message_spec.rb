require 'spec_helper'

describe Ayl::Message do

  context "Initialization" do

    it "should accept an object, selector options and a set of arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.should == options
      m.arguments.should == [ "arg1", "arg2" ]
    end

    it "should accept an object, selector options and no arguments" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options)
      
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.should == options
      m.arguments.should == [ ]
    end

  end

  context "Code generation" do
    
    it "should generate code when arguments are present" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      m.to_rrepr.should == "\"object\".method_name(\"arg1\", \"arg2\")"
    end

    it "should generate code when no arguments are present" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options)
      m.to_rrepr.should == "\"object\".method_name()"
    end

  end

  context "Message Packaging" do
    
    it "should package up the message into a hash" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")
      m.to_hash.should == { :type => :ayl, :code => "\"object\".method_name(\"arg1\", \"arg2\")" }
    end

    it "should be able to create a message from a hash with code that has arguments" do
      m_hash = { :type => :ayl, :code => "\"object\".method_name(\"arg1\", \"arg2\")" }
      m = Ayl::Message.from_hash(m_hash)
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.arguments.should == [ "arg1", "arg2" ]
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments" do
      m_hash = { :type => :ayl, :code => "\"object\".method_name()" }
      m = Ayl::Message.from_hash(m_hash)
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.arguments.should == [ ]
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has no arguments and no parens" do
      m_hash = { :type => :ayl, :code => "\"object\".method_name" }
      m = Ayl::Message.from_hash(m_hash)
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.arguments.should == [ ]
      m.to_hash.should === m_hash
    end

    it "should be able to create a message from a hash with code that has one arguments with multiple parens" do
      m_hash = { :type => :ayl, :code => "\"object\".method_name('string'.length())" }
      m = Ayl::Message.from_hash(m_hash)
      m.object.should == "object"
      m.selector.should == :method_name
      m.options.is_a?(Ayl::MessageOptions).should be_true
      m.arguments.should == [6 ]
      m.to_hash.should === m_hash
    end

  end

  context "Code Evaluation" do
    
    it "should evaluate the code associated with the message" do
      array_of_nums = [ 3, 2, 8, 1 ]
      m = Ayl::Message.new(array_of_nums, :length, Ayl::MessageOptions.new)
      m.evaluate.should == 4
    end

  end

end
