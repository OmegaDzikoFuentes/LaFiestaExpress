class Rack::Attack
  throttle("api/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api")
  end

  throttle("logins/email", limit: 5, period: 1.minute) do |req|
    if req.path == "/login" && req.post?
      req.params["email"].presence
    end
  end
end
