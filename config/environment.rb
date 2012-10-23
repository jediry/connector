# Load the rails application
require File.expand_path('../application', __FILE__)

# Configure email
ActionMailer::Base.smtp_settings = {
    :user_name => 'mhdt-connect',
    :password => 's3ndmeee',
    :domain => 'mhdt-connect.herokuapp.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}

# Initialize the rails application
Connector::Application.initialize!
