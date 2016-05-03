module Karen
  module Runescape
    class ItemHistory < Karen::Model::Base
      attr_accessible id: :id, day: :day, price: :price, trend: :trend, max_buy_price: :max_buy_price, max_sell_price: :max_sell_price,
                      buy_price: :buy_price, sell_price: :sell_price, buy_rate: :buy_rate, sell_rate: :sell_rate

      attribute :day
      attribute :price
      attribute :trend
      attribute :max_buy_price
      attribute :max_sell_price
      attribute :buy_price
      attribute :sell_price
      attribute :buy_rate
      attribute :sell_rate

      reference :item, 'Karen::Slack::Item'
    end
  end
end
