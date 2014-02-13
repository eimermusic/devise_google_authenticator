require 'rotp'
require 'yubikey'

module Devise # :nodoc:
  module Models # :nodoc:

    module OtpAuthenticatable

      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          before_validation :assign_auth_secret

          attr_accessor :new_yubikey_id
          validate :new_yubikey_verification
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

        # def assign_tmp
        #   self.update_attributes(:gauth_tmp => ROTP::Base32.random_base32(32), :gauth_tmp_datetime => DateTime.now)
        #   self.gauth_tmp
        # end


        # Yubikey methods
        def new_yubikey_verification
          return if is_same_old_yubikey? || new_yubikey_id.nil?

          if new_yubikey_id.match(/\A\w{44}\z/)
            if Yubikey::OTP::Verify.new(:otp => new_yubikey_id).valid?
              self.yubikey_id = new_yubikey_id[0..11]
            end
          else
            errors.add :yubikey_id, I18n.t(:yubikey_id_is_invalid)
          end

        rescue Yubikey::OTP::InvalidOTPError
          errors.add :yubikey_id, I18n.t(:yubikey_id_is_invalid)
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

        def set_gauth_enabled(params)
          self.update_without_password(params)
        end

        def gauth_totp
          @gauth_totp ||= ROTP::TOTP.new(self.gauth_secret)
        end

        def gauth_totp_uri
          gauth_totp.provisioning_uri("#{Rails.application.class.parent_name}:#{email}")
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

        def require_token?(cookie)
          if self.class.ga_remembertime.nil? || cookie.blank?
            return true
          end
          array = cookie.to_s.split ','
          if array.count != 2
            return true
          end
          last_logged_in_email = array[0]
          last_logged_in_time = array[1].to_i
          return last_logged_in_email != self.email || (Time.now.to_i - last_logged_in_time) > self.class.ga_remembertime.to_i
        end

        private

        def is_same_old_yubikey?
          self.yubikey_id == new_yubikey_id.to_s[0..11]
        end

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random_base32(secret_size) unless self.gauth_secret.present?
        end

        def secret_size
          32
        end
      end

      module ClassMethods # :nodoc:
        def find_by_mfa_tmp_token(mfa_tmp_token)
          to_adapter.find_first(:mfa_tmp_token => mfa_tmp_token)
        end
        ::Devise::Models.config(self, :ga_timeout, :ga_timedrift, :ga_remembertime)
      end
    end
  end
end
