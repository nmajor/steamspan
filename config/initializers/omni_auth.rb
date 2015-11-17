Rails.application.config.middleware.use OmniAuth::Builder do
  steam_key = ENV["STEAM_API_KEY"] || YAML.load_file('config/steam.yml')["api_key"]
  provider :steam, steam_key
end
