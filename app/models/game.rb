class Game < ActiveRecord::Base
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
    data = {queryString: self.game_name}
    response = RestClient.send(:post, url, data)
    noko = Nokogiri.HTML(response)
    if noko.css('#suggestionsList_main > li').first
      beat_time_text = noko.css('#suggestionsList_main > li').first.css('.gamelist_tidbit')[1].text
      self.beat_time = convert_beat_time_text_to_minutes beat_time_text
    else
      self.beat_time = 0
    end
    self.save
  end

  def convert_beat_time_text_to_minutes text
    words = text.split ' '
    return 0 if !words[1]
    case words[1].downcase
    when "minutes" || 'minute' || 'm'
      return words[0].to_i
    when "hours" || 'hour' || 'h'
      return words[0].to_i * 60
    end
    0
  end
end
