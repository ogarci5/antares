module JLPT
  class Grammar
    class << self
      def all
        Rails.cache.fetch('jlpt_grammar') {ActiveSupport::JSON.decode(File.read('jlpt_grammar.json'))}
      end

      def where(options = {})
        return all unless options[:level]
        Rails.cache.fetch("jlpt_#{options[:level]}_grammar") {ActiveSupport::JSON.decode(File.read("jlpt_#{options[:level]}_grammar.json"))}
      end
    end
  end
end