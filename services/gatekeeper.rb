module Gatekeeper
  extend Mote::Helpers

  def self.invite(email)
    mail = {
      to: email,
      subject: "Activate your account",
      text: mote("mails/invite.mote", url: url(:activate, email)),
    }

    Mailer.deliver(mail)
  end

  def self.reset(user)
    mail = {
      to: user.email,
      subject: "Password reset",
      text: mote("mails/reset.mote", url: url(:reset, user.id)),
    }

    Mailer.deliver(mail)
  end

  def self.url(action, str)
    sprintf("%s/%s/%s", $env["HOST"], action, encode(str))
  end

  def self.signer
    Nobi::TimestampSigner.new($env["NOBI_SECRET"])
  end

  def self.encode(str)
    signer.sign(str)
  end

  def self.decode(str, ttl = Float($env["NOBI_EXPIRE"]))
    signer.unsign(str, max_age: ttl)
  rescue Nobi::BadData
    nil
  end
end
