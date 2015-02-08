class Anime


  def self.all
    Rails.cache.fetch('anime') do
      ActiveSupport::JSON.decode(File.read('./anime.json'))
    end
  end
end