class Karen::Message
  attr_accessor :recipient, :body

  def initialize(attrs = {})
    attrs = attrs.with_indifferent_access
    @recipient = attrs[:recipient]
    @body = attrs[:body]
  end

  def deliver
    TwilioApi.new(serialize).deliver
  end

  def serialize
    {body: body, recipient: recipient}.with_indifferent_access
  end
end