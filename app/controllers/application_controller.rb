class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Set this to true to enable sending email
  def email_enabled
    false
  end
end
