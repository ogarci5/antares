class Anime
  @link = ''

  class << self
    attr_accessor :link

    def all
      Rails.cache.fetch('anime') do
        ActiveSupport::JSON.decode(File.read('./anime.json')).map{|a| a.merge({'name' => File.basename(a['link'].sub(/\/Movies\/\w\//, '').gsub('_', ' '), '.*')})}
      end
    end

    def search_by_name(search)
      all.select{|a| a['name'].jarowinkler_similar(search) > 0.6}
    end
  end
end