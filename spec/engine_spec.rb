require 'spec_helper'

describe Ayl::Engine do

  context "Engine Selection" do

    it "should return the default (synchronous) engine if no other engines are configured" do
      engine = Ayl::Engine.get_active_engine

      expect(engine).not_to be_nil
      expect(engine).to be_an_instance_of(Ayl::Engine)
    end

    it "should allow a different engine to be configured and selected if active" do
      mock_engine = double("FakeEngine")
      expect(mock_engine).to receive(:respond_to?).with(:asynchronous?).and_return(true)
      expect(mock_engine).to receive(:respond_to?).with(:is_connected?).and_return(true)
      expect(mock_engine).to receive(:is_connected?).and_return(true)
      
      Ayl::Engine.clear_engines
      Ayl::Engine.add_engine(mock_engine)

      expect(Ayl::Engine.get_active_engine).to eq(mock_engine)
    end

    it "should allow a different engine to be configured but select the default if the new one is not active" do
      mock_engine = double("FakeEngine")
      expect(mock_engine).to receive(:respond_to?).with(:asynchronous?).and_return(true)
      expect(mock_engine).to receive(:respond_to?).with(:is_connected?).and_return(true)
      expect(mock_engine).to receive(:is_connected?).and_return(false)

      Ayl::Engine.clear_engines
      Ayl::Engine.add_engine(mock_engine)

      expect(Ayl::Engine.get_active_engine).to eq(Ayl::Engine.instance)
    end

    it "should raise an exception if a new engine is added that doesn't respond to :asynchronous" do
      mock_engine = double("FakeEngine")
      expect(mock_engine).to receive(:respond_to?).with(:asynchronous?).and_return(false)
      
      expect { Ayl::Engine.add_engine(mock_engine) }.to raise_error
    end

    it "should raise an exception if a new engine is added that doesn't respond to :is_connected" do
      mock_engine = double("FakeEngine")
      expect(mock_engine).to receive(:respond_to?).with(:asynchronous?).and_return(true)
      expect(mock_engine).to receive(:respond_to?).with(:is_connected?).and_return(false)
      
      expect { Ayl::Engine.add_engine(mock_engine) }.to raise_error
    end

  end

  context "Default Engine Behavior" do
    
    before(:each) do
      @default_engine = Ayl::Engine.instance
    end

    it "should identify itself as synchronous" do
      expect(@default_engine.asynchronous?).to be false
    end

    it "should respond that it is connected" do
      expect(@default_engine.is_connected?).to be true
    end

    it "should simply execute the code provided in the message submission" do
      mock_logger = double("Ayl::Logger")
      mock_logger.stub(:debug)
      
      Ayl::Logger.instance.logger = mock_logger

      mock_message = double("Ayl::Message")

      mock_worker = double("Ayl::Worker")
      expect(mock_worker).to receive(:process_message).with(mock_message).and_return(8)
      expect(Ayl::Worker).to receive(:new).and_return(mock_worker)

      expect(@default_engine.submit(mock_message)).to eq(8)
    end

  end

end
