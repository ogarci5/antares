# TODO Implement natural language generation
module Karen
  class Message

    MESSAGES = {
      'karen/reminder' => {
        messages: [
          {text: '%s, please %s. Thank you.'},
          {text: 'Please %s. Thank you %s.', reverse: true},
          {text: 'Please %s. Thanks!', single: true},
          {text: '%s, looks like you need to %s.'},
          {text: '%s, looks like you still need to %s.'},
          {text: '%s! You have to %s! Don\'t forget!'},
          {text: '%s! You still have to %s! Don\'t forget!'},
          {text: 'Don\'t forget you need to %s.', single: true},
          {text: 'Don\'t forget you still need to %s.', single: true},
          {text: 'Time\'s running out! You need to %s %s', reverse: true},
          {text: 'Time\'s running out! You still need to %s %s', reverse: true},
          {text: 'Time\'s running out! You need to %s.', single: true},
          {text: 'Time\'s running out! You still need to %s.', single: true},
          {text: '%s, my sources have confirmed that you need to %s.'},
          {text: '%s, my sources have confirmed that you still need to %s.'},
          {text: 'My sources have confirmed that you need to %s.', single: true},
          {text: 'My sources have confirmed that you still need to %s.', single: true},
          {text: '%s, my sources say that you need to %s.'},
          {text: '%s, my sources say that you still need to %s.'},
          {text: 'My sources say that you need to %s.', single: true},
          {text: 'My sources say that you still need to %s.', single: true},
          {text: '%s, a little bird told me that you should %s.'},
          {text: '%s, a little bird told me that you still have to %s.'},
          {text: 'A little bird told me that you should %s.', single: true},
          {text: 'A little bird told me that you still have to %s.', single: true},
          {text: 'You know, you really should %s.', single: true},
          {text: 'You know, you really need to %s.', single: true},
          {text: '%s... You know you really should %s...', single: true},
          {text: '%s... You know you really need to %s...', single: true},
          {text: 'If you could %s, that would be great.', single: true},
          {text: 'If you could %s, that would be fantastic.', single: true},
          {text: 'If you could %s, that would be wonderful.', single: true},
          {text: '%s, if you could %s, that would be great.'},
          {text: '%s, if you could %s, that would be fantastic.'},
          {text: '%s, if you could %s, that would be wonderful.'},
          {text: '%s, I\'m counting on you to %s.'},
          {text: 'I\'m counting on you to %s.', single: true},
          {text: 'I\'m counting on you to %s %s', reverse: true},
          {text: '%s, you must have forgotten to %s. Please take care of this.'},
          {text: 'You must have forgotten to %s. Please take care of this.'}
        ]
      },
      'karen/slack' => {
        messages: [
          {text: 'There has been some movement on Slack.'},
          {text: '%s, there has been some movement on Slack.', single: true},
          {text: 'Something is happening on Slack!'},
          {text: '%s! Something is happening on Slack!', single: true},
          {text: 'You may or may not have been mentioned on Slack.'},
          {text: '%s, you may or may not have been mentioned on Slack.', single: true},
          {text: 'Have I told you how interesting Slack has been lately?'},
          {text: '%s! Have I told you how interesting Slack has been lately?', single: true}
        ]
      },
      signature: ' -Karen'
    }

    attr_reader :type, :text

    def initialize(options = {})
      @type = options[:type]
      @text = options[:text]
      @user = Karen.user
    end

    def deliver
      TwilioApi.new(self.serialize).deliver
    end

    def serialize
      {body: body, recipient: @user.phone_number}.with_indifferent_access
    end

    def body
      case type
        when 'karen/reminder'
          options = [@user.first_name, text]
          message = MESSAGES[type][:messages].shuffle.first
          options.reverse! if message[:reverse]
          options = options.reverse.first if message[:single]
          Random.new.rand(20) > 12 ? (message[:text] % options): (message[:text] % options) + MESSAGES[:signature]
        when 'karen/slack'
          options = @user.first_name
          message = MESSAGES[type][:messages].shuffle.first
          text = message[:single] ? message[:text] % options : message[:text]
          Random.new.rand(20) > 12 ? text: text + MESSAGES[:signature]
      end
    end
  end
end