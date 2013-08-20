class User < PARENT_MODEL_CLASS
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :otp_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :gauth_enabled, :mfa_tmp_token, :mfa_tmp_datetime, :email, :password, :password_confirmation, :remember_me
end
