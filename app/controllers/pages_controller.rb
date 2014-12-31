class PagesController < ApplicationController

  def home
  end

  def span

    steam_user = params[:steam_user]
    begin
      steam_id = Steam::User.vanity_to_steamid(steam_user)
      games = Steam::Player.owned_games(steam_id)["games"]
      # games = Steam::Player.owned_games(76561197993653488)["games"]
      raise Steam::SteamError if games.nil?
      game_ids = games.map{|g| g["appid"]}
    rescue Steam::SteamError, Steam::JSONError
      redirect_to :back, :alert => 'Could not find user with that name'
    else
    puts 'blahman'+steam_id.to_s

      sql = "SELECT appid, beat_time FROM games WHERE appid IN (#{game_ids.join(',')})"
      games_with_beat_time = Hash[ActiveRecord::Base.connection.exec_query(sql).rows]

      puts 'happy1 '+games.inspect
      @playtime_differential = 0
      games.each do |x|
        puts 'happy2 '+x.inspect
        playtime_difference = ( games_with_beat_time[x["appid"]] - x["playtime_forever"] )
        @playtime_differential += ( games_with_beat_time[x["appid"]] - x["playtime_forever"] ) if playtime_difference > 0
      end

      @playtime_actual = games.map { |h| h["playtime_forever"] }.sum / 60
      @playtime_total = Game.where(:appid => game_ids).sum(:beat_time) / 60
      @playtime_differential = @playtime_differential / 60


    end
  end

end