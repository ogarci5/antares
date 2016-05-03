module Karen
  module Runescape
    class API
      # For the item db for now
      BASE_URL = 'https://secure.runescape.com/m=itemdb_rs/api/'
      PAGE_LIMIT = 12

      class << self

        def execute(path)
          call = RestClient.get(BASE_URL + path)
          ActiveSupport::JSON.decode(call.body)
        end

        def info
          execute('info.json')
        end

        def category(id)
          execute("catalogue/category.json?category=#{id}")
        end

        def items(category_id, alpha, page = 1)
          execute("catalogue/items.json?category=#{category_id}&alpha=#{alpha}&page=#{page}")
        end

      end
    end
  end
end