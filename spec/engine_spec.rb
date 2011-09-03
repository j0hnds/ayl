require 'spec_helper'

describe Ayl::Engine do

  context "Engine Selection" do

    it "should return the default (synchronous) engine if no other engines are configured" do
      engine = Ayl::Engine.get_active_engine

      engine.should_not be_nil
      engine.should be_an_instance_of(Ayl::Engine)
    end

  end

  context "Default Engine Behavior" do
    
    before(:each) do
      @default_engine = Ayl::Engine.instance
    end

    it "should identify itself as synchronous" do
      @default_engine.asynchronous?.should be_false
    end

    it "should respond that it is connected" do
      @default_engine.is_connected?.should be_true
    end

    it "should simply execute the code provided in the message submission" do
      mock_message = mock("Ayl::Message")
      mock_message.should_receive(:rrepr).and_return('"a_string".length')

      @default_engine.submit(mock_message).should == 8
    end

  end

end
