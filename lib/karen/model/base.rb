class Karen::Model::Base < Ohm::Model
  include Karen::Model

  class << self
    def base_module
      to_s.tableize.split('/').second.to_sym
    end

    def base_class
      to_s.tableize.split('/').last
    end

    def display_name
      base_class.titleize
    end

    def permitted_attributes(hash)
      {}
    end

    def find(dict)
      if dict.is_a? Hash
        super dict
      else
        self.[](dict)
      end
    end

    def settings
      []
    end
  end

  def initialize(attrs = {})
    super self.class.permitted_attributes(attrs)
  end

  def model_name
    self.class.base_class.singularize
  end

  def reference_id
    "#{model_name.to_sym}_id".to_sym
  end
end