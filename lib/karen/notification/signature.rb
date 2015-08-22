class Karen::Notification::Signature < Karen::Model::Base
  attr_accessible id: :id, text: :text

  attribute :text

  def self.sample_from_order(order)
    rand = order.include?(:name) ? Random.new.rand(6) : Random.new.rand(2)
    rand = 2 if rand > 2
    find rand
  end
end