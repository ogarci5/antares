class Karen::Model::Base
  include Karen::Model

  class << self
    def base_module
      to_s.tableize.split('/').second.to_sym
    end

    def base_class
      to_s.tableize.split('/').last
    end

    def redis_key
      "#{base_module}:#{base_class}"
    end

    def redis_instance_key(id)
      "#{redis_key}:#{id}"
    end

    def display_name
      base_class.titleize
    end

    def all
      ids = Karen::Redis.get(redis_key).map { |id| redis_instance_key id }
      (Karen::Redis.mget(*ids) || []).map { |model_hash| new model_hash }
    end

    def first
      id = Karen::Redis.get(redis_key).first
      Karen::Redis.get redis_instance_key(id)
    end

    def where(attr = {})
      field, value = attr.keys.first, attr.values.first
      all.select { |model| model.send(field) == value }
    end

    def find(id)
      Karen::Redis.get redis_instance_key(id)
    end
  end

  def initialize(attrs = {})
    attrs.each do |var, value|
      instance_variable_set("@#{var}", value)
    end
  end

  def save
    format_types!
    Karen::Redis.set(redis_key, self)
  end

  def model_name
    self.class.base_class.singularize
  end

  def redis_key
    "#{redis_key}:#{id}"
  end

  private

  def format_types!
    self.class.settings_with_types.each do |setting|
      if setting[:type] == :boolean
        self.send "#{setting[:name]}=", [true, 'true', 'on'].include?(self.send(setting[:name]))
      end
    end
  end
end