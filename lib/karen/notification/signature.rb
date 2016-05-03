class Karen::Notification::Signature < Karen::Model::Base
  attr_accessible id: :id, text: :text
  set_settings :text
  attribute :text

  def self.sample_from_order(order)
    rand = order.include?('name') ? Random.new.rand(6) : Random.new.rand(2)
    rand = 2 if rand > 2 || rand == 0
    find rand
  end

  def to_s
    "Signature #{id}"
  end
end