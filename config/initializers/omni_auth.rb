Rails.application.config.middleware.use OmniAuth::Builder do
  steam_key = ENV["STEAM_API_KEY"] || ( File.exist?('config/steam.yml') ? YAML.load_file('config/steam.yml')["api_key"] : '0' )
  provider :steam, steam_key
end
