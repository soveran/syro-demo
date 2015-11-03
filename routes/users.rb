Users = Syro.new(Frontend) {
  page[:title] = "Welcome"

  @user = authenticated(User)

  on("logout") {
    get {
      logout(User)

      res.redirect "/"
    }
  }

  get {
    render("views/users/index.mote", user: @user)
  }
}
