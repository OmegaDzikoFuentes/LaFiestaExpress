Rack::Attack.throttle('api/v1', limit: 100, period: 3600) do |req|
    req.path.start_with?('/api/v1') && req.ip
  end