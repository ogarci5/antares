class SMSWorker
  @queue = :default

  def self.perform(sms)
    TwilioApi.new(sms).deliver
  end
end