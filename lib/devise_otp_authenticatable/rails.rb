module DeviseOtpAuthenticator
  class Engine < ::Rails::Engine # :nodoc:
    ActionDispatch::Callbacks.to_prepare do
      DeviseOtpAuthenticator::Patches.apply
    end

  end
end
