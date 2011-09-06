require 'spec_helper'

describe Ayl::Logger do

  context "Logger Configuration" do

    it "should respond with nil if a logger isn't configured" do
      Ayl::Logger.instance.logger.should be_nil
    end

    it "should respond with the logger set if the logger is configured" do
      mock_logger = mock("Logger")

      Ayl::Logger.instance.logger = mock_logger
      Ayl::Logger.instance.logger.should == mock_logger
    end

  end

  context "Logging" do

    it "should log calls to the logger through std out when no logger is configured" do
      Kernel.should_receive(:puts).with("DEBUG: Debug message")
      Kernel.should_receive(:puts).with("ERROR: Error message")
      Kernel.should_receive(:puts).with("FATAL: Fatal message")
      Kernel.should_receive(:puts).with("INFO: Info message")
      Kernel.should_receive(:puts).with("WARN: Warn message")
      
      Ayl::Logger.instance.logger = nil

      [ :debug, :error, :fatal, :info, :warn ].each do |method|
        Ayl::Logger.instance.send(method, "#{method.to_s.capitalize} message")
      end
    end

    it "should log calls to the configured logger" do
      mock_logger = mock("Logger")
      mock_logger.should_receive(:debug).with("Debug message")
      mock_logger.should_receive(:error).with("Error message")
      mock_logger.should_receive(:fatal).with("Fatal message")
      mock_logger.should_receive(:info).with("Info message")
      mock_logger.should_receive(:warn).with("Warn message")

      Ayl::Logger.instance.logger = mock_logger
      
      [ :debug, :error, :fatal, :info, :warn ].each do |method|
        Ayl::Logger.instance.send(method, "#{method.to_s.capitalize} message")
      end
    end

  end

end
