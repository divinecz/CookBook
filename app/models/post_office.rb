class PostOffice < ActionMailer::Base
  def registration(user)
    recipients  user.email
    bcc         "novotnyales@gmail.com"
    from        "O vaření.cz <poslicek@ovareni.cz>"
    subject     "Registrace kuchařky na www.ovareni.cz"
    sent_on     Time.now
    body        :user => user
  end
end
