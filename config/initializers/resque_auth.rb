Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ENV['RESQUE_PW']
end
