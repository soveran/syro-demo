Guests = Syro.new(Frontend) {
  page[:title] = "Welcome"

  get {
    render("views/guests/index.mote")
  }

  on("login") {
    page[:title] = "Login"

    get {
      render("views/guests/login.mote")
    }

    post {
      on(login(User, req[:email], req[:password]) != nil) {
        remember

        res.redirect "/"
      }

      session[:alert] = "Invalid login"

      render("views/guests/login.mote")
    }
  }

  on("signup") {
    @invite = Invite.new(req[:invite] || {})

    page[:title] = "Signup"

    get {
      render("views/guests/signup.mote", invite: @invite)
    }

    post {
      on(@invite.valid?) {
        Gatekeeper.invite(@invite.email)

        session[:alert] = "Check your email"

        res.redirect "/login"
      }

      on(true) {
        session[:alert] = "Invalid signup"

        render("views/guests/signup.mote", invite: @invite)
      }
    }
  }

  on("activate") {
    on(:token) {
      @invite = Invite[Gatekeeper.decode(inbox[:token])]

      on(@invite.valid?) {
        get {
          render("views/guests/update.mote")
        }

        post {
          on(req[:password] != nil) {
            @signup = Signup.new(email: @invite.email, password: req[:password])

            on(@signup.valid?) {
              @user = User.create(@signup.attributes)

              authenticate(@user)

              session[:alert] = "Password updated"

              res.redirect "/"
            }

            on(true) {
              res.write "invalid"
              res.write @signup.errors
            }
          }

          on(true) {
            session[:alert] = "Invalid password"

            render("views/guests/update.mote")
          }
        }
      }

      on(true) {
        session[:alert] = "Invalid or expired URL"

        res.redirect "/reset"
      }
    }
  }

  on("reset") {
    get {
      render("views/guests/reset.mote")
    }

    post {
      @user = User.fetch(req[:email])

      on(@user != nil) {
        Gatekeeper.reset(@user)

        session[:alert] = "Check your email"

        res.redirect "/login"
      }

      on(true) {
        session[:alert] = "Invalid email"

        render("views/guests/reset.mote")
      }
    }

    on(:token) {
      @user = User[Gatekeeper.decode(inbox[:token])]

      on(@user != nil) {
        get {
          render("views/guests/update.mote")
        }

        post {
          on(req[:password] != nil) {
            @user.update(password: req[:password])

            authenticate(@user)

            session[:alert] = "Password updated"

            res.redirect "/"
          }

          on(true) {
            session[:alert] = "Invalid password"

            render("views/guests/update.mote")
          }
        }
      }

      on(true) {
        session[:alert] = "Invalid or expired URL"

        res.redirect "/reset"
      }
    }
  }
}
