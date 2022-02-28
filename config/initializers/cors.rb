Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://www.haxball.com", "http://www.haxball.com"
    resource "*", headers: :any, methods: [:get, :post, :patch, :put, :delete, :options, :head]
  end
end
