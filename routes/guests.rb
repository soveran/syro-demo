Guests = Syro.new(Frontend) do
  page[:title] = "Welcome"

  get do
    render("views/guests/index.mote")
  end

  on "login" do
    page[:title] = "Login"

    get do
      render("views/guests/login.mote")
    end

    post do
      on login(User, req[:email], req[:password]) != nil do
        remember

        res.redirect "/"
      end

      session[:alert] = "Invalid login"

      render("views/guests/login.mote")
    end
  end

  on "signup" do
    @invite = Invite.new(req[:invite] || {})

    page[:title] = "Signup"

    get do
      render("views/guests/signup.mote", invite: @invite)
    end

    post do
      on @invite.valid? do
        Gatekeeper.invite(@invite.email)

        session[:alert] = "Check your email"

        res.redirect "/login"
      end

      default do
        session[:alert] = "Invalid signup"

        render("views/guests/signup.mote", invite: @invite)
      end
    end
  end

  on "activate" do
    on :token do
      @invite = Invite[Gatekeeper.decode(inbox[:token])]

      on @invite.valid? do
        get do
          render("views/guests/update.mote")
        end

        post do
          on req[:password] != nil do
            @signup = Signup.new(email: @invite.email, password: req[:password])

            on @signup.valid? do
              @user = User.create(@signup.attributes)

              authenticate(@user)

              session[:alert] = "Password updated"

              res.redirect "/"
            end

            default do
              res.write "invalid"
              res.write @signup.errors
            end
          end

          default do
            session[:alert] = "Invalid password"

            render("views/guests/update.mote")
          end
        end
      end

      default do
        session[:alert] = "Invalid or expired URL"

        res.redirect "/reset"
      end
    end
  end

  on "reset" do
    get do
      render("views/guests/reset.mote")
    end

    post do
      @user = User.fetch(req[:email])

      on @user != nil do
        Gatekeeper.reset(@user)

        session[:alert] = "Check your email"

        res.redirect "/login"
      end

      default do
        session[:alert] = "Invalid email"

        render("views/guests/reset.mote")
      end
    end

    on :token do
      @user = User[Gatekeeper.decode(inbox[:token])]

      on @user != nil do
        get do
          render("views/guests/update.mote")
        end

        post do
          on req[:password] != nil do
            @user.update(password: req[:password])

            authenticate(@user)

            session[:alert] = "Password updated"

            res.redirect "/"
          end

          default do
            session[:alert] = "Invalid password"

            render("views/guests/update.mote")
          end
        end
      end

      default do
        session[:alert] = "Invalid or expired URL"

        res.redirect "/reset"
      end
    end
  end
end
