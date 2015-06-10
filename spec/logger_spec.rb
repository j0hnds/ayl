require 'spec_helper'

describe Ayl::Logger do

  before(:each) do
    Ayl::Logger.instance.logger = nil
  end

  context "Logger Configuration" do

    it "should respond with nil if a logger isn't configured" do
      expect(Ayl::Logger.instance.logger).to be_nil
    end

    it "should respond with the logger set if the logger is configured" do
      mock_logger = double("Logger")

      Ayl::Logger.instance.logger = mock_logger
      expect(Ayl::Logger.instance.logger).to be mock_logger
    end

  end

  context "Logging" do

    it "should log calls to the logger through std out when no logger is configured" do
      expect(Kernel).to receive(:puts).with("DEBUG: Debug message")
      expect(Kernel).to receive(:puts).with("ERROR: Error message")
      expect(Kernel).to receive(:puts).with("FATAL: Fatal message")
      expect(Kernel).to receive(:puts).with("INFO: Info message")
      expect(Kernel).to receive(:puts).with("WARN: Warn message")
      
      Ayl::Logger.instance.logger = nil

      [ :debug, :error, :fatal, :info, :warn ].each do |method|
        Ayl::Logger.instance.send(method, "#{method.to_s.capitalize} message")
      end
    end

    it "should log calls to the configured logger" do
      mock_logger = double("Logger")
      expect(mock_logger).to receive(:debug).with("Debug message")
      expect(mock_logger).to receive(:error).with("Error message")
      expect(mock_logger).to receive(:fatal).with("Fatal message")
      expect(mock_logger).to receive(:info).with("Info message")
      expect(mock_logger).to receive(:warn).with("Warn message")

      Ayl::Logger.instance.logger = mock_logger
      
      [ :debug, :error, :fatal, :info, :warn ].each do |method|
        Ayl::Logger.instance.send(method, "#{method.to_s.capitalize} message")
      end
    end

  end

end
