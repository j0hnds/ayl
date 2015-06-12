require 'spec_helper'

describe Ayl::Extensions do

  class ExtendedClass
    include Ayl::Extensions
  end

  context "Send methods" do

    before(:each) do
      @cut = ExtendedClass.new
    end

    it "should delegate the call to ayl_send to ayl_send_opts" do
      expect(@cut).to receive(:ayl_send_opts).with(:something, {}, "arg1", "arg2")
      @cut.ayl_send(:something, "arg1", "arg2")
    end

    it "should have the message submit the call from ayl_send_opts" do
      mock_engine = double("Ayl::Engine")

      expect(Ayl::Engine).to receive(:get_active_engine).and_return(mock_engine)
      
      mock_message_opts = double("Ayl::MessageOptions")
      expect(Ayl::MessageOptions).to receive(:new).with({}).and_return(mock_message_opts)
      
      mock_message = double("Ayl::Message")

      expect(Ayl::Message).to receive(:new).
        with(@cut, :something, mock_message_opts, "arg1", "arg2").
        and_return(mock_message)
      expect(mock_engine).to receive(:submit).with(mock_message)

      @cut.ayl_send_opts(:something, {}, "arg1", "arg2")
    end

    it "should extend a common set up classes" do
      [ Array, Hash, Module, Numeric, Range, String, Symbol ].each do |c|
        expect(c).to respond_to :ayl_send
        expect(c).to respond_to :ayl_send_opts
      end
    end

  end

end
