module Karen
  module Model
    def schema(*attrs)
      attr_accessor *attrs
      module_eval do
        define_method :serialize do
          attrs.inject({}) {|hsh, sym| hsh[sym] = self.send(sym); hsh} || {}
        end

        define_method :attributes do
          attrs
        end
      end
    end
  end
end