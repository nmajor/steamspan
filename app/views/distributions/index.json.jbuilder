json.array!(@distributions) do |distribution|
  json.extract! distribution, :id, :description, :minutes, :image
  json.url distribution_url(distribution, format: :json)
end
