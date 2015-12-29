class OperatorMailer < ApplicationMailer
  def notify_no_operator_mail_request(params)
    @shop = params[:shop]
    @name = params[:name]
    @email = params[:email]
    @question = params[:question]
    mail(from: "#{@name} <#{@email}>", bcc: @shop.email, subject: "New question from #{@name}")
  end

  def send_transcript(params)
    @transcript = params[:transcript]
    @email = params[:email]
    mail(to: @email, subject: 'Download Transcript')
  end
end
