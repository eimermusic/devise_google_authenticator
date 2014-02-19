class Devise::CheckgaController < Devise::SessionsController
  prepend_before_filter :devise_resource, :only => [:show]
  prepend_before_filter :require_no_authentication, :only => [ :show, :update ]

  include Devise::Controllers::Helpers

  def show
    @tmpid = params[:id]
    if @tmpid.nil?
      redirect_to :root
    else
      render :show
    end
  end

  def update
    resource = resource_class.find_by_mfa_tmp_token(params[resource_name]['tmpid'])

    if not resource.nil?

      if resource.verify_mfa_token(params[resource_name]['otp_token'])
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name,resource)
        respond_with resource, :location => after_sign_in_path_for(resource)

        if params[resource_name]['remember_otp_token'] == '1' && !resource.class.ga_remembertime.nil?
          cookies.signed[:otp_memory] = {
            :value => resource.email << "," << Time.now.to_i.to_s,
            :secure => !(Rails.env.test? || Rails.env.development?),
            :expires => (resource.class.ga_remembertime + 1.days).from_now
          }
        end
      else
        set_flash_message(:error, :invalid_token) if is_flashing_format?
        render :show
      end

    else
      set_flash_message(:error, :session_expired) if is_flashing_format?
      redirect_to :root
    end
  end


  private

  def devise_resource
    self.resource = resource_class.new
  end
end