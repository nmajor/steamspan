class Game < ActiveRecord::Base
  validates_numericality_of :beat_time

  def self.create_with_appid aid
    "blah"
  end

  def name
    game_name
  end

  def get_beat_time
    return true if !self.beat_time.blank?
    get_beat_time!
  end

  def get_beat_time!
    url = "http://www.howlongtobeat.com/search_main.php?t=games&page=1&sorthead=popular&sortd=Normal%20Order&plat=&detail=0"
    data = {queryString: self.simple_name}
    response = RestClient.send(:post, url, data)
    noko = Nokogiri.HTML(response)
    if noko.css('#suggestionsList_main > li').first
      (0..7).each do |x|
        break if self.beat_time && self.beat_time > 0
        beat_time_text = noko.css('#suggestionsList_main > li').first.css('.gamelist_tidbit')[x].text if noko.css('#suggestionsList_main > li').first.css('.gamelist_tidbit')[x]     
        self.beat_time = convert_beat_time_text_to_minutes beat_time_text
      end
    else
      self.beat_time = 0
    end
    self.save if self.beat_time_changed?
  end

  def convert_beat_time_text_to_minutes text
    return 0 if text.nil?
    words = text.split ' '
    return 0 if !words[1]
    time = words[1].downcase
    if time.in? %w( minutes minute m )
      return words[0].to_i
    elsif time.in? %w( hours hour h )
      return words[0].to_i * 60
    end
    0
  end

  def simple_name
    tmp_name = name
    [
      "®",      
      "™",      
      ":",      
      "Collector's Edition",      
      "Edition",      
      "(TM)",      
      "TM",      
    ].each do |x|
      tmp_name.gsub!(x, '')
    end
    tmp_name
  end
end
