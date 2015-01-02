Rails.application.config.middleware.use OmniAuth::Builder do
  provider :steam, YAML.load_file('config/steam.yml')["apikey"]
end
