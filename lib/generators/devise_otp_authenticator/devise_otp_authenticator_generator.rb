module DeviseOtpAuthenticator
	module Generators
		class DeviseOtpAuthenticatorGenerator < Rails::Generators::NamedBase

			namespace "devise_otp_authenticator"

			desc "Add :otp_authenticatable directive in the given model, plus accessors. Also generate migration for ActiveRecord"

			def inject_devise_google_authenticator_content
				path = File.join("app","models","#{file_path}.rb")
				inject_into_file(path, "otp_authenticatable, :", :after => "devise :") if File.exists?(path)
				inject_into_file(path, "gauth_enabled, :mfa_tmp_token, :mfa_tmp_datetime, :", :after => "attr_accessible :") if File.exists?(path)
			end

			hook_for :orm

		end
	end
end