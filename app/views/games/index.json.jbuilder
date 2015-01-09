json.array!(@games) do |game|
  json.extract! game, :id, :game_name, :beat_time, :appid
  json.url game_url(game, format: :json)
end
