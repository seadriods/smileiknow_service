# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Smileiknow::Application.initialize!

Smileiknow::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address  => "smtp.gmail.com",
    :port     => 587,
    :domain   => "seadriods.net",
    :authentication => "plain",
    :user_name => "seadriods",
    :password  => "xxxxxxxx",
    :enable_starttls_auto => true    
  }
end
