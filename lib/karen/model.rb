module Karen
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attr_accessible(attrs = {})
        attrs = attrs.with_indifferent_access
        (class << self; self; end).instance_eval do
          define_method(:permitted_attributes) do |hash|
            permitted_hash = Hash[hash.map{|k,v| [attrs[k],v]}]
            permitted_hash.delete(nil)
            permitted_hash
          end
        end
      end

      def set_settings(*attrs)
        (class << self; self; end).instance_eval do
          define_method(:settings) { attrs }
        end
      end

      def scope(name, proc)
        (class << self; self; end).instance_eval do
          define_method(name, &proc)
        end
      end
    end
  end
end