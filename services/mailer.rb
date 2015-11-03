module Mailer
  MissingSubject = Class.new(ArgumentError)
  MissingText    = Class.new(ArgumentError)

  def self.deliver(message)
    raise MissingSubject if message[:subject].nil?
    raise MissingText    if message[:text].nil?

    defaults = {
      to: "info@example.com",
      bcc: "info@example.com",
      from: "info@example.com"
    }

    Malone.deliver(defaults.merge(message))
  end
end
