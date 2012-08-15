class SMSNotifier

  def self.exist_user_notify(invite)

  end

  def self.new_user_notify(invite)

  end


  private

  def self.send_message(phone, text)
    api.send_message(phone, text)
  end

  def self.api
    @api ||= Clickatell::API.authenticate('your_api_id', 'your_username', 'your_password')
  end

end