require 'spec_helper'

describe Ayl::Mailer do

  before(:each) do
    Ayl::Mailer.instance.mailer = nil
  end

  context 'Mailer configuration' do

    context "#logger" do

      it "should respond with nil if a mailer isn't configured" do
        Ayl::Mailer.instance.mailer.should be_nil
      end

      it "should raise an error if an attempt is made to configure the mailer with an invalid object" do
        lambda { Ayl::Mailer.instance.mailer = Object.new }.should raise_error
      end

      it "should allow a valid mailer to be configured" do
        mock_mailer = mock("MyMailer")
        mock_mailer.stub(:ayl_message)

        lambda { Ayl::Mailer.instance.mailer = mock_mailer }.should_not raise_error
        Ayl::Mailer.instance.mailer.should == mock_mailer
      end

    end

  end

  context "Sending messages" do

    context '#deliver_message' do

      it "should do nothing if no mailer is configured" do
        Ayl::Mailer.instance.deliver_message("The message")
      end

      it "should deliver a message and no stack trace if a valid mailer is configured" do
        mock_mailer = mock("MyMailer")
        mock_mailer.should_receive(:ayl_message).with('The Message', nil).and_return do
          mock("MailMessage").tap do | mail_message |
            mail_message.should_receive(:deliver)
          end
        end

        Ayl::Mailer.instance.mailer = mock_mailer

        Ayl::Mailer.instance.deliver_message('The Message')
      end

      it "should deliver a message and a stack trace if a valid mailer is configured" do
        mock_mailer = mock("MyMailer")
        mock_mailer.should_receive(:ayl_message).with('The Message', 'StackTrace').and_return do
          mock("MailMessage").tap do | mail_message |
            mail_message.should_receive(:deliver)
          end
        end

        Ayl::Mailer.instance.mailer = mock_mailer

        Ayl::Mailer.instance.deliver_message('The Message', 'StackTrace')
      end

    end

  end

end
