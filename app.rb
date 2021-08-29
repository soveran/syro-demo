require "syro"
require "mote"
require "ohm"
require "shield"
require "hache"
require "scrivener"
require "nobi"
require "malone"
require "tas"

# Workaround a bug in Rack 2.2.2
require "delegate"

# Path to project components
GLOB = "./{lib,decks,routes,models,filters,services}/*.rb"

# Load components
Dir[GLOB].each { |file| require file }

# Connect to SMTP server
Malone.connect(url: $env["MALONE_URL"], tls: false, domain: "example.com")

# Connect to Redis
Ohm.redis = Redic.new($env["REDIS_URL"])

# Main Syro application. It uses the `Frontend` deck, and you can
# find it in `./decks/frontend.rb`. Refer to the Syro tutorial for
# more information about Decks and other customizations.
Web = Syro.new(Frontend) do

  # The authenticated helper is included by Shield, and in this case
  # it returns an instance of User (if one is authenticated), or nil
  # otherwise. Depending on the result, we run the routes for Users
  # or Guests. Those routes are defined in `./routes/users.rb` and
  # `./routes/guests.rb`.
  authenticated(User) ?
    run(Users) :
    run(Guests)
end

# Rack application
App = Rack::Builder.new do
  use Rack::MethodOverride
  use Rack::Session::Cookie, secret: $env["RACK_SESSION_SECRET"]
  use Rack::Static, urls: %w[/css /fonts /img], root: "./public"

  run(Web)
end
