ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => ENV['MAILER_USERNAME'],
    :password             => ENV['MAILER_PASSWORD'],
    :authentication       => 'login',
    :enable_starttls_auto => true
}