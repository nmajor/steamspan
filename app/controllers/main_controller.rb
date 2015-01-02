class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [ :callback, :callback_fail ]

  def home
  end

  def callback
    steam_id = request.env['omniauth.auth'][:extra][:raw_info][:steamid]
    redirect_to span_path(:steam_id => steam_id)
  end

  def callback_fail
    redirect_to root_path, :alert => "There was a problem signing in with steam. Please try again."
  end

  def span_by_name
    steam_user = params[:steam_user]

    if steam_user.blank?
      redirect_to root_path, :alert => 'Hey, you need to enter a Steam id.'
      return
    end

    begin
      steam_id = Steam::User.vanity_to_steamid(steam_user)
    rescue Steam::SteamError
      redirect_to span_path(:steam_id => steam_user)
      return
    end
    redirect_to span_path(:steam_id => steam_id)
  end

  def span

    steam_id = params[:steam_id]
    begin
      games = Steam::Player.owned_games(steam_id)["games"]
      raise Steam::SteamError if games.nil?
      game_ids = games.map{|g| g["appid"]}
    rescue Steam::SteamError, Steam::JSONError
      redirect_to :back, :alert => 'Could not find user with that name'
    else
      sql = "SELECT appid, beat_time FROM games WHERE appid IN (#{game_ids.join(',')})"
      games_with_beat_time = Hash[ActiveRecord::Base.connection.exec_query(sql).rows]

      @playtime_differential = 0
      games.each do |x|
        if !games_with_beat_time[x["appid"]]
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
      @share_desc = "It would take me #{@playtime_differential / 60} hours or #{minutes_to_words_flat(@playtime_differential)} of continuous gameplay to beat my Steam library"

      steam_user = Steam::User.summary(steam_id)
      @steam_avatar = Steam::User.summary(steam_id)["avatarmedium"]
      @steam_avatar_big = Steam::User.summary(steam_id)["avatarfull"]
      @steam_personaname = steam_user["personaname"]

    end
  end

  private
  def minutes_to_words_flat mm
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    "#{dd} days, #{hh} hours, #{mm} minutes".html_safe
  end

end
