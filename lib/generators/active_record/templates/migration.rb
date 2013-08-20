class DeviseOtpAuthenticatorAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table :<%= table_name %> do |t|
      t.string  :gauth_secret
      t.string  :gauth_enabled, :default => "f"
      t.string  :yubikey_id
      t.string  :yubikey_enabled, :default => "f"
      t.string  :mfa_tmp_token
      t.datetime  :mfa_tmp_datetime
    end

  end

  def self.down
    change_table :<%= table_name %> do |t|
      t.remove :gauth_secret, :gauth_enabled, :yubikey_id, :yubikey_enabled, :mfa_tmp_token, :mfa_tmp_datetime
    end
  end
end
