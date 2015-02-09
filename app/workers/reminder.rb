class MailWorker
  @queue = :default

  def self.perform(message)
    puts "This message was emailed"
  end
end