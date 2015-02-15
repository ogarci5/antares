# TODO Implement natural language generation
module Karen
  class Message

    MESSAGES = {
      'karen/reminder' => {
        messages: [
          {text: '%s, please %s. Thank you.', order: [:name, :text]},
          {text: 'Please %s. Thank you %s.', order: [:text, :name]},
          {text: 'Please %s. Thanks!', order: [:text]},
          {text: '%s, looks like you need to %s.', order: [:name, :text]},
          {text: '%s, looks like you still need to %s.', order: [:name, :text]},
          {text: '%s! You have to %s! Don\'t forget!', order: [:name, :text]},
          {text: '%s! You still have to %s! Don\'t forget!', order: [:name, :text]},
          {text: 'Don\'t forget you need to %s.', order: [:text]},
          {text: 'Don\'t forget you still need to %s.', order: [:text]},
          {text: 'Time\'s running out! You need to %s %s', order: [:text, :name]},
          {text: 'Time\'s running out! You still need to %s %s', order: [:text, :name]},
          {text: 'Time\'s running out! You need to %s.', order: [:text]},
          {text: 'Time\'s running out! You still need to %s.', order: [:text]},
          {text: '%s, my sources have confirmed that you need to %s.', order: [:name, :text]},
          {text: '%s, my sources have confirmed that you still need to %s.', order: [:name, :text]},
          {text: 'My sources have confirmed that you need to %s.', order: [:text]},
          {text: 'My sources have confirmed that you still need to %s.', order: [:text]},
          {text: '%s, my sources say that you need to %s.', order: [:name, :text]},
          {text: '%s, my sources say that you still need to %s.', order: [:name, :text]},
          {text: 'My sources say that you need to %s.', order: [:text]},
          {text: 'My sources say that you still need to %s.', order: [:text]},
          {text: '%s, a little bird told me that you should %s.', order: [:name, :text]},
          {text: '%s, a little bird told me that you still have to %s.', order: [:name, :text]},
          {text: 'A little bird told me that you should %s.', order: [:text]},
          {text: 'A little bird told me that you still have to %s.', order: [:text]},
          {text: 'You know, you really should %s.', order: [:text]},
          {text: 'You know, you really need to %s.', order: [:text]},
          {text: '%s... You know you really should %s...', order: [:text]},
          {text: '%s... You know you really need to %s...', order: [:text]},
          {text: 'If you could %s, that would be great.', order: [:text]},
          {text: 'If you could %s, that would be fantastic.', order: [:text]},
          {text: 'If you could %s, that would be wonderful.', order: [:text]},
          {text: '%s, if you could %s, that would be great.', order: [:name, :text]},
          {text: '%s, if you could %s, that would be fantastic.', order: [:name, :text]},
          {text: '%s, if you could %s, that would be wonderful.', order: [:name, :text]},
          {text: '%s, I\'m counting on you to %s.', order: [:name, :text]},
          {text: 'I\'m counting on you to %s.', order: [:text]},
          {text: 'I\'m counting on you to %s %s', order: [:text, :name]},
          {text: '%s, you must have forgotten to %s. Please take care of this.', order: [:name, :text]},
          {text: 'You must have forgotten to %s. Please take care of this.', order: [:name, :text]}
        ]
      },
      'karen/slack' => {
        messages: [
          {text: 'There has been some movement on Slack.', order: []},
          {text: '%s, there has been some movement on Slack.', order: [:name]},
          {text: 'Something is happening on Slack!', order: []},
          {text: '%s! Something is happening on Slack!', order: [:name]},
          {text: 'You may or may not have been mentioned on Slack.', order: []},
          {text: '%s, you may or may not have been mentioned on Slack.', order: [:name]},
          {text: 'Have I told you how interesting Slack has been lately?', order: []},
          {text: '%s! Have I told you how interesting Slack has been lately?', order: [:name]},
          {text: 'You have received a message from %s.', order: [:text]},
          {text: '%s! You have received a message from %s.', order: [:name, :text]},
          {text: 'Slackbot told me to tell you that there\'s a new message in %s.', order: [:text]},
          {text: '%s, Slackbot told me to tell you that there\'s a new message in %s.', order: [:name, :text]}
        ]
      },
      signatures: ['', ' - Karen', ' - Karen :)']
    }

    attr_reader :type, :text, :name

    def initialize(options = {})
      @type = options[:type]
      @text = options[:text]
      @user = Karen.user
      @name = @user.first_name
      @previous_message = Rails.cache.read('previous_message') || ''
    end

    def deliver
      TwilioApi.new(self.serialize).deliver
    end

    def serialize
      {body: body, recipient: @user.phone_number}.with_indifferent_access
    end

    def body
      # Make sure we aren't too similar
      begin
        message = MESSAGES[type][:messages].shuffle.first
      end until message[:text].levenshtein_similar(@previous_message) < 0.6

      options = message[:order].map{|o| self.send(o)}
      Rails.cache.write('previous_message', message[:text])

      rand = message[:order].include?(:name) ? Random.new.rand(6) : Random.new.rand(2)
      rand = 2 if rand > 2

      (message[:text] % options) + MESSAGES[:signatures][rand]
    end
  end
end
