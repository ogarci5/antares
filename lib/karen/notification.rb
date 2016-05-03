module Karen
  module Notification

    # Loading scheme, can either be from file or from an API source.
    def self.load!
      # Check if we've been loaded
      return if Message.all.to_a.first
      notifications = ActiveSupport::JSON.decode File.read(File.dirname(__FILE__) + '/resources/notification.json')
      notifications['messages'].each { |message| Message.create message }
      notifications['signatures'].each { |signature| Signature.create signature }
    end

    def self.models
      %w(Message Signature).map { |model| "#{to_s}::#{model}".constantize }
    end
  end
end