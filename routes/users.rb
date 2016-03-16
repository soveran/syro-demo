Users = Syro.new(Frontend) do
  page[:title] = "Welcome"

  @user = authenticated(User)

  on "logout" do
    get do
      logout(User)

      res.redirect "/"
    end
  end

  get do
    render("views/users/index.mote", user: @user)
  end
end
