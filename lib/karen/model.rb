module Karen
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def schema(*attrs)
        attr_accessor *attrs
        define_method :serialize do
          attrs.inject({}) {|hsh, sym| hsh[sym] = self.send(sym); hsh} || {}
        end

        define_method(:attributes) { attrs }

        (class << self; self; end).instance_eval do
          define_method(:attributes) { attrs }
        end
      end

      def scope(name, proc)
        (class << self; self; end).instance_eval do
          define_method(name, &proc)
        end
      end

      def set_settings(*attrs)
        attrs = attrs.flatten
        (class << self; self; end).instance_eval do
          define_method(:settings) { attrs.map { |attr| attr[:name] } }
          define_method(:settings_with_types) { attrs }
        end
      end
    end
  end
end