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

  context "Message Submission" do
    
    it "should submit a message" do
      options = Ayl::MessageOptions.new
      m = Ayl::Message.new("object", :method_name, options, "arg1", "arg2")

      mock_engine = mock("Engine")
      mock_engine.should_receive(:put).with("\"object\".method_name(\"arg1\", \"arg2\")", options)

      Ayl::Engine.should_receive(:get_active_engine).and_return(mock_engine)
      m.submit
    end
  end

end
