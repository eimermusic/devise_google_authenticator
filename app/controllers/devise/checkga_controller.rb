class Devise::CheckgaController < Devise::SessionsController
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

      if resource.verify_mfa_token(params[resource_name]['token'])
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(resource_name,resource)
        respond_with resource, :location => after_sign_in_path_for(resource)
      else
        set_flash_message(:error, :invalid_token) if is_navigational_format?
        redirect_to :root
      end

    else
      set_flash_message(:error, :session_expired) if is_navigational_format?
      redirect_to :root
    end
  end
end