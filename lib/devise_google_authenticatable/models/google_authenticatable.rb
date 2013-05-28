require 'rotp'
require 'yubikey'

module Devise # :nodoc:
  module Models # :nodoc:

    module GoogleAuthenticatable

      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          before_validation :assign_auth_secret
          before_validation :trim_yubikey_id
          include InstanceMethods
        end
      end

      module InstanceMethods # :nodoc:
        ## General MFA Stuff ##
        def mfa_enabled?
          !!gauth_enabled || !!yubikey_enabled
        end

        def verify_mfa_token(unverified_otp)
          return false unless unverified_otp.present? && self.mfa_tmp_datetime.present? && (self.mfa_tmp_datetime > self.class.ga_timeout.ago)
          case
          when !!gauth_enabled && unverified_otp.match(/\A\d{6}\z/)
            verify_gauth_totp(unverified_otp)
          when !!yubikey_enabled && unverified_otp.match(/\A\w{44}\z/)
            veryfy_yubikey_otp(unverified_otp)
          else
            false
          end
        end


        # Yubikey methods
        def trim_yubikey_id
          self.yubikey_id = yubikey_id[0..11] if yubikey_id.present?
        end

        def veryfy_yubikey_otp(yubikey_otp)
          begin
            otp = Yubikey::OTP::Verify.new(:otp => yubikey_otp)
            if otp.valid? && yubikey_id == yubikey_otp[0..11]
              return true
            else
              return false
            end
          rescue Yubikey::OTP::InvalidOTPError
            return false
          end
        end

        # Google Authenticator methods
        def get_gauth_secret
          self.gauth_secret
        end

        def set_gauth_enabled(param)
          self.update_without_password(param)
        end

        def gauth_totp
          @gauth_totp ||= ROTP::TOTP.new(self.gauth_secret)
        end

        def gauth_totp_uri
          gauth_totp.provisioning_uri("#{username_from_email(email)}@#{Rails.application.class.parent_name}")
        end

        def assign_mfa_tmp_token
          self.update_attributes(:mfa_tmp_token => ROTP::Base32.random_base32, :mfa_tmp_datetime => DateTime.now)
          self.mfa_tmp_token
        end

        def verify_gauth_totp(token)
          valid_vals = []
          valid_vals << gauth_totp.at(Time.now)
          (1..self.class.ga_timedrift).each do |cc|
            valid_vals << gauth_totp.at(Time.now.ago(30*cc))
            valid_vals << gauth_totp.at(Time.now.in(30*cc))
          end

          valid_vals.include?(token.to_i)
        end

        private

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random_base32 unless self.gauth_secret.present?
        end

        def username_from_email(email)
          (/^(.*)@/).match(email)[1]
        end
      end

      module ClassMethods # :nodoc:
        def find_by_mfa_tmp_token(mfa_tmp_token)
          to_adapter.find_first(:mfa_tmp_token => mfa_tmp_token)
        end
        ::Devise::Models.config(self, :ga_timeout, :ga_timedrift)
      end
    end
  end
end
