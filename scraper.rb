class AnimeScraper

  BASE_URI = 'please change me'
  ALPHA = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)

  attr_accessor :base_uri, :page_info, :anime

  def initialize(base_uri = BASE_URI)
    @base_uri = base_uri
    @page_info = {}
    @anime = []
  end

  def page_scrape(letter, page = 1)
    full_url = base_uri+"#{letter}#{page}.html"
    doc = Nokogiri::HTML(open(full_url))

    unless page_info[letter]
      page_numbers = doc.css('a').select{|link| link.attr('href').match(/#{letter}\d*\.html/) if link.attr('href')}
                .map{|c| c.attr('href').sub(letter, '').sub('.html', '').to_i}.sort.uniq.reject{|n| n == 1}
      page_info.merge!({letter => page_numbers})
    end

    doc.css('area').select{|link| link.attr('href')}.each do |link|
      parent = link.parent.parent.parent.parent
      info = parent.children.select{|t| t.name == 'td'}.map{|t| t.text.strip}
      next if info[2] != 'English' || info[3] == 'Stream'
      anime << {language: info[1], subtitle: info[2], size: info[3].gsub(/[ \n]/, ''), link: '/'+link.attr('href')}
    end
  rescue OpenURI::HTTPError
    warn "HTTP Error when accessing #{full_url}"
    page_info[letter].reject!{|pg| pg == page}
  end

  def write_to_file(name = 'anime.json')
    File.open(name, 'w+') do |file|
      file.puts anime.to_json
    end
    puts "Wrote to file #{name}"
  end

  def run
    ALPHA.each do |letter|
      puts "On letter #{letter.capitalize}"
      page_scrape(letter)
      page_info[letter].each do |page|
        page_scrape(letter, page)
      end unless page_info[letter].include?(0)
    end

    write_to_file
  end
end