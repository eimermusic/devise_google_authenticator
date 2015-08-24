require 'active_support/core_ext/integer'
require 'active_support/core_ext/string'
require 'active_support/ordered_hash'
require 'active_support/concern'
require 'devise'

module Devise # :nodoc:
  mattr_accessor :ga_timeout
  @@ga_timeout = 3.minutes

  mattr_accessor :ga_timedrift
  @@ga_timedrift = 90.seconds

  mattr_accessor :ga_remembertime
  @@ga_remembertime = 1.month
end

# a security extension for devise
module DeviseOtpAuthenticator
  autoload :Schema, 'devise_otp_authenticatable/schema'
  autoload :Patches, 'devise_otp_authenticatable/patches'
end



require 'devise_otp_authenticatable/routes'
require 'devise_otp_authenticatable/rails'
require 'devise_otp_authenticatable/controllers/helpers'
ActionView::Base.send :include, DeviseOtpAuthenticator::Controllers::Helpers

Devise.add_module :otp_authenticatable, :controller => :otp_authenticatable, :model => 'devise_otp_authenticatable/models/otp_authenticatable', :route => :displayqr