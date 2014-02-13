module DeviseOtpAuthenticator
  module Patches
    autoload :DisplayQR, 'devise_otp_authenticatable/patches/display_qr'
    autoload :CheckGA, 'devise_otp_authenticatable/patches/check_ga'

    class << self
      def apply
        #Devise::RegistrationsController.send(:include, Patches::DisplayQR)
        Devise::SessionsController.send(:include, Patches::CheckGA)
      end
    end
  end
end
