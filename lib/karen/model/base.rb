class Karen::Model::Base
  extend Karen::Model

  class << self
    def base_module
      to_s.tableize.split('/').second.to_sym
    end

    def base_class
      to_s.tableize.split('/').last
    end

    def all
      (Karen::Redis.get(base_module)[base_class] || []).map { |model_hash| new model_hash }
    end

    def first
      all.first
    end

    def where(attr = {})
      field, value = attr.keys.first, attr.values.first
      all.select { |model| model.send(field) == value }
    end

    def find(id)
      where(id: id).first
    end
  end

  def initialize(attrs = {})
    attrs.each do |var, value|
      instance_variable_set("@#{var}", value)
    end
  end

  def save
    data = Karen::Redis.get(self.class.base_module)
    data[self.class.base_class] = data[self.class.base_class].map { |model| model['id'] == id ? self : model }
    Karen::Redis.set(self.class.base_module, data)
  end
end