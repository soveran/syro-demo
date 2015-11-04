prepare do
  Ohm.redis = Redic.new($env["REDIS_TEST_URL"])
  Ohm.redis.call("FLUSHDB")
end

setup do
  Driver.new(App)
end

test do |driver|

  # Homepage features

  driver.get("/")

  assert_equal 200, driver.last_response.status

  expected = %Q(<title>Welcome</title>)

  assert driver.last_response.body[expected]

  expected = %Q(<a href="/login">Login</a>)

  assert driver.last_response.body[expected]

  expected = %Q(<a href="/signup">Signup</a>)

  assert driver.last_response.body[expected]

  # Signup process

  driver.get("/signup")

  assert_equal 200, driver.last_response.status

  expected = %Q(<title>Signup</title>)

  assert driver.last_response.body[expected]

  expected = %Q(<form action="/signup" method="POST">)

  assert driver.last_response.body[expected]

  driver.post("/signup")

  assert_equal 200, driver.last_response.status

  expected = %Q(Invalid signup)

  assert driver.last_response.body[expected]

  invite = {
    "email" => "foo@example.com",
  }

  driver.post("/signup", "invite" => invite)

  assert_equal 302, driver.last_response.status

  driver.follow_redirect!

  expected = %Q(Check your email)

  assert driver.last_response.body[expected]

  regex = /\/activate\/\S+/

  url = Malone.deliveries.last.text[regex]

  assert url != nil

  driver.get(url)

  assert_equal 200, driver.last_response.status

  expected = %Q(<h1>Update your password</h1>)

  assert driver.last_response.body[expected]

  expected = %Q(<form action="#{url}" method="POST">)

  assert driver.last_response.body[expected]

  user = {
    "password" => "bar",
  }

  driver.post(url, user)

  assert_equal 302, driver.last_response.status

  driver.follow_redirect!

  assert_equal 200, driver.last_response.status

  expected = %Q(<a href="/logout">Logout</a>)

  driver.get("/logout")

  assert_equal 302, driver.last_response.status

  driver.follow_redirect!

  expected = %Q(<title>Welcome</title>)

  assert driver.last_response.body[expected]

  # Login process

  driver.get("/login")

  assert_equal 200, driver.last_response.status

  expected = %Q(<title>Login</title>)

  assert driver.last_response.body[expected]

  expected = %Q(<form action="/login" method="POST">)

  assert driver.last_response.body[expected]

  driver.post("/login")

  assert_equal 200, driver.last_response.status

  expected = %Q(Invalid login)

  assert driver.last_response.body[expected]

  user = {
    "email" => "foo@example.com",
    "password" => "bar",
  }

  driver.post("/login", user)

  assert_equal 302, driver.last_response.status

  driver.follow_redirect!

  expected = %Q(<a href="/logout">Logout</a>)

  assert driver.last_response.body[expected]
  assert driver.last_response.body[user["email"]]

  driver.get("/logout")

  # Password recovery process

  driver.get("/login")

  assert_equal 200, driver.last_response.status

  expected = %Q(<a href="/reset">Forgot password?</a>)

  assert driver.last_response.body[expected]

  driver.get("/reset")

  expected = %Q(<form action="/reset" method="POST">)

  assert driver.last_response.body[expected]

  driver.post("/reset")

  assert_equal 200, driver.last_response.status

  expected = %Q(Invalid email)

  assert driver.last_response.body[expected]

  user = {
    "email" => "foo@example.com",
  }

  driver.post("/reset", user)

  regex = /\/reset\/\S+/

  url = Malone.deliveries.last.text[regex]

  assert url != nil

  driver.get("/reset/42.bad-token")

  assert_equal 302, driver.last_response.status

  driver.follow_redirect!

  assert_equal 200, driver.last_response.status

  expected = %Q(Invalid or expired URL)

  assert driver.last_response.body[expected]

  driver.get(url)

  assert_equal 200, driver.last_response.status

  expected = %Q(<h1>Update your password</h1>)

  assert driver.last_response.body[expected]

  expected = %Q(<form action="#{url}" method="POST">)

  assert driver.last_response.body[expected]

  user = {
    "password" => "baz",
  }

  driver.post(url, user)

  assert_equal 302, driver.last_response.status

  driver.follow_redirect!

  assert_equal 200, driver.last_response.status

  expected = %Q(<a href="/logout">Logout</a>)

  assert driver.last_response.body[expected]
end
