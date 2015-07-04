module JLPT
  class Kanji
    class << self
      def all
        Rails.cache.fetch('jlpt_kanji') {ActiveSupport::JSON.decode(File.read('jlpt_kanji.json'))}
      end

      def where(options = {})
        return all unless options[:level]
        Rails.cache.fetch("jlpt_#{options[:level]}_kanji") {ActiveSupport::JSON.decode(File.read("jlpt_#{options[:level]}_kanji.json"))}
      end
    end
  end
end