module DeviseOtpAuthenticator::Patches
  # patch Sessions controller to check that the OTP is accurate
  module CheckGA
    extend ActiveSupport::Concern
    included do

      define_method :override_create do
        resource = warden.authenticate!(auth_options)
        if devise_mapping.otp_authenticatable? && resource.mfa_enabled? && resource.require_token?(cookies.signed[:otp_memory])
          tmpid = resource.assign_mfa_tmp_token
          warden.logout

          # we head back into the checkga controller with the temporary id
          respond_with resource, :location => { :controller => 'checkga', :action => 'show', :id => tmpid}
        end
      end
      before_filter :override_create, only: :create

    end
  end
end
