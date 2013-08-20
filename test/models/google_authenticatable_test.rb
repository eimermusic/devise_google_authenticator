require 'test_helper'
require 'model_tests_helper'

class OtpAuthenticatableTest < ActiveSupport::TestCase

	def setup
		new_user
	end

	test 'new users have a non-nil secret set' do
		assert_not_nil User.find(1).gauth_secret
	end

	test 'new users should have gauth_enabled disabled by default' do
		assert_equal 0, User.find(1).gauth_enabled.to_i
	end

	test 'get_gauth_secret method works' do
		assert_not_nil User.find(1).get_gauth_secret
	end

	test 'updating gauth_enabled to true' do
		User.find(1).set_gauth_enabled(:gauth_enabled => 1)
		assert_equal 1, User.find(1).gauth_enabled.to_i
	end

	test 'updating gauth_enabled back to false' do
		User.find(1).set_gauth_enabled(:gauth_enabled => 0)
		assert_equal 0, User.find(1).gauth_enabled.to_i
	end

	test 'updating the mfa_tmp_token key' do
		User.find(1).assign_mfa_tmp_token

		assert_not_nil User.find(1).mfa_tmp_token
		assert_not_nil User.find(1).mfa_tmp_datetime

		sleep(1)

		old_tmp = User.find(1).mfa_tmp_token
		old_dt = User.find(1).mfa_tmp_datetime

		User.find(1).assign_mfa_tmp_token

		assert_not_equal old_tmp, User.find(1).mfa_tmp_token
		assert_not_equal old_dt, User.find(1).mfa_tmp_datetime
	end

	test 'testing class method for finding by tmp key' do
		assert User.find_by_mfa_tmp_token('invalid').nil?
		assert !User.find_by_mfa_tmp_token(User.find(1).mfa_tmp_token).nil?
	end

	test 'testing token validation' do
		assert !User.find(1).verify_gauth_totp('1')
		assert !User.find(1).verify_gauth_totp(ROTP::TOTP.new(User.find(1).get_gauth_secret).at(Time.now))

		User.find(1).assign_mfa_tmp_token

		assert !User.find(1).verify_gauth_totp('1')
		assert User.find(1).verify_gauth_totp(ROTP::TOTP.new(User.find(1).get_gauth_secret).at(Time.now))
	end

end