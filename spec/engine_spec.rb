require 'spec_helper'

describe Ayl::Engine do

  context "Engine Selection" do

    it "should return the default (synchronous) engine if no other engines are configured" do
      engine = Ayl::Engine.get_active_engine

      engine.should_not be_nil
      engine.should be_an_instance_of(Ayl::Engine)
    end

    it "should allow a different engine to be configured and selected if active" do
      mock_engine = mock("FakeEngine")
      mock_engine.should_receive(:respond_to?).with(:asynchronous?).and_return(true)
      mock_engine.should_receive(:respond_to?).with(:is_connected?).and_return(true)
      mock_engine.should_receive(:is_connected?).and_return(true)
      
      Ayl::Engine.clear_engines
      Ayl::Engine.add_engine(mock_engine)

      Ayl::Engine.get_active_engine.should == mock_engine
    end

    it "should allow a different engine to be configured but select the default if the new one is not active" do
      mock_engine = mock("FakeEngine")
      mock_engine.should_receive(:respond_to?).with(:asynchronous?).and_return(true)
      mock_engine.should_receive(:respond_to?).with(:is_connected?).and_return(true)
      mock_engine.should_receive(:is_connected?).and_return(false)

      Ayl::Engine.clear_engines
      Ayl::Engine.add_engine(mock_engine)

      Ayl::Engine.get_active_engine.should == Ayl::Engine.instance
    end

    it "should raise an exception if a new engine is added that doesn't respond to :asynchronous" do
      mock_engine = mock("FakeEngine")
      mock_engine.should_receive(:respond_to?).with(:asynchronous?).and_return(false)
      
      lambda { Ayl::Engine.add_engine(mock_engine) }.should raise_error
    end

    it "should raise an exception if a new engine is added that doesn't respond to :is_connected" do
      mock_engine = mock("FakeEngine")
      mock_engine.should_receive(:respond_to?).with(:asynchronous?).and_return(true)
      mock_engine.should_receive(:respond_to?).with(:is_connected?).and_return(false)
      
      lambda { Ayl::Engine.add_engine(mock_engine) }.should raise_error
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
      mock_logger = mock("Ayl::Logger")
      mock_logger.stub(:debug)
      
      Ayl::Logger.instance.logger = mock_logger

      mock_message = mock("Ayl::Message")

      mock_worker = mock("Ayl::Worker")
      mock_worker.should_receive(:process_message).with(mock_message).and_return(8)
      Ayl::Worker.should_receive(:new).and_return(mock_worker)

      @default_engine.submit(mock_message).should == 8
    end

  end

end
