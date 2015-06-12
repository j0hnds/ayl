require 'spec_helper'

describe Ayl::Mailer do

  before(:each) do
    Ayl::Mailer.instance.mailer = nil
  end

  context 'Mailer configuration' do

    context "#deliver_message" do

      it "should respond with nil if a mailer isn't configured" do
        expect(Ayl::Mailer.instance.mailer).to be_nil
      end

      it "should raise an error if an attempt is made to configure the mailer with an invalid object" do
        expect { Ayl::Mailer.instance.mailer = Object.new }.to raise_error
      end

      it "should allow a valid mailer to be configured" do
        mock_mailer = double("MyMailer")
        mock_mailer.stub(:ayl_message)
        mock_mailer.stub(:burying_job)

        expect { Ayl::Mailer.instance.mailer = mock_mailer }.not_to raise_error
        expect(Ayl::Mailer.instance.mailer).to be mock_mailer
      end

    end

  end

  context "Sending messages" do

    context '#deliver_message' do

      it "should do nothing if no mailer is configured" do
        Ayl::Mailer.instance.deliver_message("The message")
      end

      it "should deliver a message and no stack trace if a valid mailer is configured" do
        mock_mailer = double("MyMailer")
        mock_message = double("MailMessage")
        expect(mock_message).to receive(:deliver)
        expect(mock_mailer).to receive(:ayl_message).
          with('The Message', nil).
          and_return(mock_message)
        mock_mailer.stub(:burying_job)

        Ayl::Mailer.instance.mailer = mock_mailer

        Ayl::Mailer.instance.deliver_message('The Message')
      end

      it "should deliver a message and a stack trace if a valid mailer is configured" do
        mock_mailer = double("MyMailer")
        mock_message = double("MailMessage")
        expect(mock_message).to receive(:deliver)
        expect(mock_mailer).to receive(:ayl_message).
          with('The Message', 'StackTrace').
          and_return(mock_message)
        mock_mailer.stub(:burying_job)

        Ayl::Mailer.instance.mailer = mock_mailer

        Ayl::Mailer.instance.deliver_message('The Message', 'StackTrace')
      end

    end

    context '#burying_job' do

      it "should deliver a message if a valid mailer is configured" do
        mock_mailer = double("MyMailer")
        mock_message = double("MailMessage")
        expect(mock_message).to receive(:deliver)
        expect(mock_mailer).to receive(:burying_job).
          with('1 + 2').
          and_return(mock_message)
        mock_mailer.stub(:ayl_message)

        Ayl::Mailer.instance.mailer = mock_mailer

        Ayl::Mailer.instance.burying_job('1 + 2')
      end
    end

  end

end
