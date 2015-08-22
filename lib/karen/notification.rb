module Karen
  module Notification

    # Loading scheme, can either be from file or from an API source.
    def self.load!
      notifications = ActiveSupport::JSON.decode File.read(File.dirname(__FILE__) + '/resources/notification.json')

      notifications['messages'].each do |message|
        Karen::Notification::Message.create message
      end

      notifications['signatures'].each do |signature|
        Karen::Notification::Signature.create signature
      end
    end

    def self.models
      %w(messages signatures).map { |model| "karen/notification/#{model}".classify.constantize }
    end
  end
end