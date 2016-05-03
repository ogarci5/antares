module Karen
  module Runescape
    class Item < Karen::Model::Base
      attr_accessible id: :id, name: :name, item_id: :item_id, image_url: :image_url

      attribute :name
      attribute :item_id
      attribute :image_url

      reference :category, 'Karen::Slack::Category'
      collection :histories, 'Karen::Slack::ItemHistory'

      def detail
        API.item(id)
      end
    end
  end
end
