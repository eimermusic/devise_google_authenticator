# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name = "devise_otp_authenticator"
  s.version = "0.3.8"
  s.authors = ["Christian Frichot", "Martin Westin"]
  s.date = "2014-02-13"
  s.description = "One Time Password Authenticator Extension for Devise. Supporting OATH TOTP (a.k.a Gogole Authenticator) and Yubikey OTP"
  s.email = "xntrik@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE.txt README.rdoc]
  s.homepage = "http://github.com/eimermusic/devise_otp_authenticator"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "One Time Password Authenticator Extension for Devise"

  s.required_ruby_version = '>= 1.9.3'
  s.required_rubygems_version = '>= 2.1.0'

  s.add_development_dependency('bundler', '~> 1.3.0')

  {
    'railties' => '>= 3.0',
    # removed the following to try and get past this bundle update not finding compatible versions for gem issue
    # 'actionmailer' => '>= 3.0',
    'actionmailer' => '>= 3.2.12',
    'devise' => '>= 3.2.0',
    'rotp'   => '~> 2.1.1',
    'yubikey'=> '~> 1.4.1'
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end


end