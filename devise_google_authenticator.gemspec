# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
Gem::Specification.new do |s|
  s.name = "devise_google_authenticator"
  s.version = "0.3.3"
  s.authors = ["Christian Frichot", "Martin Westin"]
  s.date = "2012-05-27"
  s.description = "One Time Password Authenticator Extension for Devise. Supporting OATH TOTP (a.k.a Gogole Authenticator) and Yubikey OTP"
  s.email = "xntrik@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE.txt README.rdoc]
  s.homepage = "http://github.com/AsteriskLabs/devise_google_authenticator"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "One Time Password Authenticator Extension for Devise"

  s.required_ruby_version = '>= 1.9.2'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency('bundler', '~> 1.1')

  {
    'rails'  => ['>= 3.0.0', '<= 3.3.0'],
    'devise' => ['>= 2.0.0', '<= 2.9.0'],
    'rotp'   => ['<= 1.3.2'],
    'yubikey'=> ['<= 1.3.1']
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end

end