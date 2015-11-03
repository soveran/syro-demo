require_relative "../app"
require "rack/test"
require "malone/test"

class Driver
  include Rack::Test::Methods

  def initialize(app)
    @app = app
  end

  def app
    @app
  end
end

