class MainController < ApplicationController

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

      sql = "SELECT appid, beat_time FROM games WHERE appid IN (#{game_ids.join(',')})"
      games_with_beat_time = Hash[ActiveRecord::Base.connection.exec_query(sql).rows]

      @playtime_differential = 0
      games.each do |x|
        unless games_with_beat_time[x["appid"]]
          g = Game.find_by_appid( x["appid"] )
          g.get_beat_time
          games_with_beat_time[x["appid"]] = g.beat_time
        end
        playtime_difference = ( games_with_beat_time[x["appid"]] - x["playtime_forever"] )
        @playtime_differential += ( games_with_beat_time[x["appid"]] - x["playtime_forever"] ) if playtime_difference > 0
      end

      @playtime_actual = games.map { |h| h["playtime_forever"] }.sum
      @playtime_total = Game.where(:appid => game_ids).sum(:beat_time)
      @playtime_differential = @playtime_differential
      @distribution = Distribution.get_within_limits @playtime_differential

    end
  end

end