require 'sinatra'

$links = []
get '/' do
  '<a href="%s">Song</a>' % $links.shuffle.first
end


def run_tamu_scraper
  song_names = [] # has to be set
  doc = Nokogiri::HTML(File.read('sample.html'))
  song_links = doc.css('a').select{|a| a.children.first && a.children.first.name == 'text'}.uniq{|a| a.text}.select{|a| song_names.select{|s| a.text.sub(/.*\-\ /, '').pair_distance_similar(s) >= 0.7}.present? }
  ids = song_links.map{|a| a.parent.css('em').text.scan(/\d{6}/).first}.count
  links = ids.map{|i| 'http://mediamatrix.tamu.edu/download_published_file.php?published_file_id=%s' % i}

  links = []

  driver = Selenium::WebDriver.for :firefox
  driver.navigate.to links.first
  el = driver.find_element(id: 'username')
  el.send_keys 'ogarci5'
  el = driver.find_element(id: 'password')
  el.send_keys 'Lun898265'
  el.submit

  wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  links.each do |link|
    driver.navigate.to link
    loc = wait.until { driver.find_element(id: 'container_video').attribute('src') }
    name = wait.until { driver.find_element(css: '#details h1').text }
    `wget #{loc}`
    temp_file = Dir.entries('.').select{|l| l.include? 'temp'}.first
    File.rename(temp_file, name)
  end
end