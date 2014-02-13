module DeviseOtpAuthenticator
  module Generators # :nodoc:
    # Install Generator
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Install the devise google authenticator extension"

      def add_configs
        inject_into_file "config/initializers/devise.rb", "\n  # ==> Devise Google Authenticator Extension\n  # Configure extension for devise\n\n" +
        "  # Require the adapter for your ORM:\n" +
        "  # require 'devise_otp_authenticatable/orm/YOUR_ORM'\n\n" +
        "  # How long should the user have to enter their token. To change the default, uncomment and change the below:\n" +
        "  # config.ga_timeout = 3.minutes\n\n" +
        "  # Change time drift settings for valid token values. To change the default, uncomment and change the below:\n" +
        "  # config.ga_timedrift = 3\n\n" +
        "  # Change setting to how long to remember device before requiring another token. Change to nil to turn feature off.\n" +
        "  # To change the default, uncomment and change the below:\n" +
        "  # config.ga_remembertime = 1.month\n\n" +
        "\n", :before => /end[ |\n|]+\Z/
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.otp_authenticator.en.yml"
      end
    end
  end
end