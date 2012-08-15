class SMSNotifier
  include Rails.application.routes.url_helpers
  self.default_url_options = ActionMailer::Base.default_url_options

  def exist_user_notify(invite)
    puts '*'*100
    puts '***'+'Send in SMS'+'***'
    p build_message(invite)
    puts '*'*100
    #send_message(invite.phone, build_message(invite))
  end

  def self.instance
    @instance ||= SMSNotifier.new
  end

  private

  def build_message(invite)
    av = ActionView::Base.new(Rails.root.join('app', 'views'))
    url = project_invite_url(invite.project, invite)
    av.assign({:invite => invite, :url => url})
    av.render(:template => "invites_mailer/exist_user_notify", :formats => [:text])
  end

  def send_message(phone, text)
    api.send_message(phone, text.strip)
  end

  def api
    @api ||= Clickatell::API.authenticate(*SMS_CONFIG)
  end

end