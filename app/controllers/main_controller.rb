class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [ :callback, :callback_fail ]

  def home
  end

  def about
  end

  def privacy
  end

  def stats
    @biggest_playtime_differential = UserStat.all.order('minutes desc').first.minutes
    @average_playtime_differential = UserStat.average(:minutes).to_i
    @total_playtime_differential = UserStat.sum(:minutes).to_i
    @total_steamids_checked = UserStat.all.size
    @distribution = Distribution.get_within_limits @total_playtime_differential
    @refresh_stats = true
  end

  def fresh_stats
    @biggest_playtime_differential = UserStat.all.order('minutes desc').first.minutes
    @average_playtime_differential = UserStat.average(:minutes).to_i
    @total_playtime_differential = UserStat.sum(:minutes).to_i
    @total_steamids_checked = UserStat.all.size

    data = {
      :biggest_playtime_differential => { :hours => view_context.number_with_delimiter(minutes_to_hours(@biggest_playtime_differential)), :words => view_context.minutes_to_words(@biggest_playtime_differential) },
      :average_playtime_differential => { :hours => view_context.number_with_delimiter(minutes_to_hours(@average_playtime_differential)), :words => view_context.minutes_to_words(@average_playtime_differential) },
      :total_playtime_differential   => { :hours => view_context.number_with_delimiter(minutes_to_hours(@total_playtime_differential)),   :words => view_context.minutes_to_words(@total_playtime_differential) },
      :total_steamids_checked        => view_context.number_with_delimiter(@total_steamids_checked),
    }

    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: data }
    end
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

    @steam_id = params[:steam_id]
    begin
      games = Steam::Player.owned_games(@steam_id)["games"]
      raise Steam::SteamError if games.nil?
      game_ids = games.map{|g| g["appid"]}
    rescue Steam::SteamError, Steam::JSONError
      redirect_to root_path, :alert => 'Could not find user with that name'
    else
      sql = "SELECT appid, beat_time FROM games WHERE appid IN (#{game_ids.join(',')})"
      games_with_beat_time = Hash[ActiveRecord::Base.connection.exec_query(sql).rows]

      @playtime_differential = 0
      games.each do |x|
        if !games_with_beat_time[x["appid"]]
          g = Game.find_by_appid( x["appid"] )
          g.get_beat_time if g
          games_with_beat_time[x["appid"]] = g.beat_time if g
        end
        next unless games_with_beat_time[x["appid"]]
        playtime_difference = ( games_with_beat_time[x["appid"]] - x["playtime_forever"] )
        @playtime_differential += ( games_with_beat_time[x["appid"]] - x["playtime_forever"] ) if playtime_difference > 0
      end

      @playtime_actual = games.map { |h| h["playtime_forever"] }.sum
      @playtime_total = Game.where(:appid => game_ids).sum(:beat_time)
      @playtime_differential = @playtime_differential
      @distribution = Distribution.get_within_limits @playtime_differential
      @share_desc = (@playtime_differential > 0) ? "It would take me #{@playtime_differential / 60} hours or #{minutes_to_words_flat(@playtime_differential)} of continuous gameplay to beat my Steam library" : "Holy Shit! I've completed my entire steam library."

      steam_user = Steam::User.summary(@steam_id)
      @steam_avatar = steam_user["avatarmedium"]
      @steam_avatar_big = steam_user["avatarfull"]
      @steam_personaname = steam_user["personaname"]

      user_stat = UserStat.find_by_steamid(@steam_id)
      user_stat ||= UserStat.new(steamid: @steam_id)
      user_stat.minutes = @playtime_differential
      user_stat.save
    end
  end

  def breakdown
    steam_id = params[:steam_id]
    begin
      @games = Steam::Player.owned_games(steam_id, params: {:include_appinfo => 1})["games"]
      raise Steam::SteamError if @games.nil?
      game_ids = @games.map{|g| g["appid"]}
    rescue Steam::SteamError, Steam::JSONError
      redirect_to root_path, :alert => 'Could not find user with that name'
    else
      sql = "SELECT appid, beat_time FROM games WHERE appid IN (#{game_ids.join(',')})"
      games_with_beat_time = Hash[ActiveRecord::Base.connection.exec_query(sql).rows]

      @beaten_games = 0
      @playtime_differential = 0
      @games.each do |x|
        if !games_with_beat_time[x["appid"]]
          g = Game.find_by_appid( x["appid"] )
          g.get_beat_time if g
          games_with_beat_time[x["appid"]] = g.beat_time if g
        end
        next unless games_with_beat_time[x["appid"]]
        playtime_difference = ( games_with_beat_time[x["appid"]] - x["playtime_forever"] )
        x["beat_time"] = games_with_beat_time[x["appid"]]
        x["playtime_difference"] = playtime_difference > 0 ? playtime_difference : 0
        x["real_img_logo_url"] = "http://media.steampowered.com/steamcommunity/public/images/apps/#{x["appid"]}/#{x["img_logo_url"]}.jpg"
        @playtime_differential += playtime_difference if playtime_difference > 0
        @beaten_games += 1 if playtime_difference <= 0 && games_with_beat_time[x["appid"]] > 0
      end

      @total_playtime = @games.map { |h| h["playtime_forever"] }.sum
      @total_beat_time = Game.where(:appid => game_ids).sum(:beat_time)
      @sorted_games = @games.sort_by{|x| (x["playtime_difference"].blank? ? 0 : x["playtime_difference"]) }

      steam_user = Steam::User.summary(steam_id)
      @steam_avatar = steam_user["avatarmedium"]
      @steam_avatar_big = steam_user["avatarfull"]
      @steam_personaname = steam_user["personaname"]

    end
  end

  def health
    render :text => "OK"
  end

  private
  def minutes_to_words_flat mm
    mm ||= 0
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    "#{dd} days, #{hh} hours, #{mm} minutes".html_safe
  end

  def minutes_to_short_words mm
    mm ||= 0
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    str = "#{mm}m"
    str += "#{hh}h" if hh > 0
    str += "#{dd}h" if dd > 0

    str
  end

  def minutes_to_hours mm
    mm / 60
  end
end
