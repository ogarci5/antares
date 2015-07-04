module JLPT
  class Vocab
    class << self
      def all
        Rails.cache.fetch('jlpt_vocab') {ActiveSupport::JSON.decode(File.read('jlpt_vocab.json'))}
      end

      def where(options = {})
        return all unless options[:level]
        Rails.cache.fetch("jlpt_#{options[:level]}_vocab") {ActiveSupport::JSON.decode(File.read("jlpt_#{options[:level]}_vocab.json"))}
      end
    end
  end
end