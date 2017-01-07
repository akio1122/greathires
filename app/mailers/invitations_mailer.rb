class InvitationsMailer < ActionMailer::Base
  default from: "\"Great Hires Support\" <no-reply@greathires.co>"

  def send_invite to, subject, body
  	body.gsub!("\n", "<br>")
    mail(to: to, subject: subject) do |format|
      format.html { render text: body.html_safe }
    end
  end
end
