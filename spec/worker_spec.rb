require 'spec_helper'

describe Ayl::Worker do

  context "Messages Processing" do

    before(:each) do
      Ayl::Logger.instance.logger = nil
      @worker = Ayl::Worker.new
    end

    it "should raise an exception if receive is called on an engine that is not asynchronous" do
      Kernel.stub(:puts)
      expect { @worker.process_messages }.to raise_error(RuntimeError, "synchronous worker cannot receive messages")
    end

  end

  context "Message Processing" do

    it "should be able to invoke the code for a message" do
    end

  end

end
