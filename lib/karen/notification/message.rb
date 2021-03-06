# TODO Implement natural language generation
class Karen::Notification::Message < Karen::Model::Base
  attr_accessible id: :id, body: :body, type: :type, order: :order
  attr_accessor :text

  set_settings :body, :type, :order

  attribute :body
  attribute :type
  attribute :order, ->(order){ eval order.to_s }

  unique :body

  index :type

  # Make sure we aren't too similar
  def self.sample_from_type(type)
    message = find(type: type).to_a.sample
    previous_message = Rails.cache.read('previous_message') || ''
    iterations = 0

    while message.body.levenshtein_similar(previous_message) > 0.6 && iterations < 10 do
      message = find(type: type).to_a.sample
      iterations += 1
    end

    message
  end

  def self.generate(type:, text:)
    message = sample_from_type(type)
    message.text = text
    message
  end

  def to_s
    "Message #{id}"
  end

  def user
    Karen.user || User.admin
  end

  def name
    user.first_name
  end

  def deliver
    Rails.cache.write('previous_message', body)
    TwilioApi.new(serialize).deliver
  end

  def serialize
    {body: parsed_body, recipient: user.phone_number}.with_indifferent_access
  end

  def parsed_body
    (body % order.map{|o| self.send(o)}) + Karen::Notification::Signature.sample_from_order(order).text
  end
end