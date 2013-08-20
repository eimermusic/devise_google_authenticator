$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'test_helper'
require 'rails/generators'
require 'generators/devise_otp_authenticator/devise_otp_authenticator_generator'

class GeneratorsTest < ActiveSupport::TestCase
  RAILS_APP_PATH = File.expand_path("../rails_app", __FILE__)

  test "rails g should include the 3 generators" do
    @output = `cd #{RAILS_APP_PATH} && rails g`
    assert @output.match(%r|DeviseOtpAuthenticator:\n  devise_otp_authenticator\n  devise_otp_authenticator:install\n  devise_otp_authenticator:views|)
  end

  test "rails g devise_otp_authenticator:install" do
    @output = `cd #{RAILS_APP_PATH} && rails g devise_otp_authenticator:install -p`
    assert @output.match(%r^(inject|insert).+config/initializers/devise\.rb\n^)
    assert @output.match(%r|create.+config/locales/devise\.otp_authenticator\.en\.yml\n|)
  end

end