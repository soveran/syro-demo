class Invite < Scrivener
  attr_accessor :email

  def self.[](email)
    new(email: email)
  end

  def validate
    if assert_present :email
      assert User.fetch(email).nil?, [:email, :not_unique]
    end
  end
end
