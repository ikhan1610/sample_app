require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
  	@user = User.new(name: "Khan", email:"foo@bar.com",
  		             password: "foobar", password_confirmation: "foobar")
  	
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should not be blank" do 
  	@user.name = "  "
  	assert_not @user.valid?
  end

  test "email should not be blank" do 
  	@user.email = "  "
  	assert_not @user.valid?
  end

  test "name should not be too long" do 
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do 
  	@user.name = "a" * 244 + '@bar.com'
  	assert_not @user.valid?
  end
  
  test "email addresses should be valid" do
  	valid_addresses = %w[
  							user@example.com 
							USER@foo.COM 
							A_US-ER@foo.bar.org
							first.last@foo.jp 
							alice+bob@baz.cn
						]
	valid_addresses.each do |valid_address|
		@user.email = valid_address
		assert @user.valid?, "#{valid_address.inspect} should be valid."
	end

  end

  test "email addresses should be invalid" do
  	invalid_addresses = %w[
  							user@example,com 
							user_at_foo.org 
							user.name@example.
							foo@bar_baz.com 
							foo@bar+baz.COM
							foo@bar..com
  						]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert_not @user.valid?, "#{invalid_address.inspect} should be invalid."
  	end
  end

  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "email addresses should be saved in downcase in the database" do
  	mixed_case_email = "Foo@BaR.COM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal @user.reload.email,mixed_case_email.downcase
  end

  test "password should not be blank" do
  	@user.password =              " " * 6
  	@user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  test "passwords should have a minimum lenght of 6 characters" do
  	@user.password =              "a" * 5
  	@user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end
end
