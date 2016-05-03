module Karen
  module Runescape
    class Category < Karen::Model::Base
      attr_accessible id: :id, name: :name

      attribute :name

      collection :items, 'Karen::Slack::Item'

      def to_s
        name
      end

      def info
        API.category(id)
      end

      def info_items(letter)
        API.items(id, letter)
      end
    end
  end
end
