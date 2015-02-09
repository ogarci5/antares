class TwilioApi

  def initialize(sms)
    @message = sms['body']
    # US-ify the recipient. May want to do this elsewhere in the future.
    @recipient = "+1#{sms['recipient']}"
    @sender = ENV['TWILIO_SENDER']
    @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH'])
  end

  def deliver
    @client.messages.create(from: @sender, to: @recipient, body: @message)
  end

end