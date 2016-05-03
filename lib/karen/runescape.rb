module Karen
  module Runescape
    # Loading scheme, can either be from file or from an API source.
    def self.load!
      # Check if we've been loaded
      return if Category.all.to_a.first
      categories = ActiveSupport::JSON.decode File.read(File.dirname(__FILE__) + '/resources/categories.json')
      categories.each { |category| Category.create category }
    end

    def self.models
      %w(Info Category Item ItemHistory).map { |model| "#{to_s}::#{model}".constantize }
    end
  end
end