require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:khan)
		
	end
  
	test "user login with invalid information" do
		get login_path
		assert_template 'sessions/new'
		post login_path, params:{session:{email: " ",password: " "}}
		assert_not is_logged_in?
		assert_not_empty flash
		assert_template 'sessions/new'
		get root_path
		assert_empty flash
	end

	test "user login with valid information followed by log out" do
		get login_path
		assert_template 'sessions/new'
		post login_path, params:{session: {email: @user.email, password: "password"}}
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_not_empty flash
		assert_select "a[href=?]", login_path, count:0
		assert_select "a[href=?]", user_path(@user)
		assert_select "a[href=?]", logout_path
		delete logout_path
		assert_not is_logged_in?
		assert_not_empty flash
		assert_redirected_to root_path
		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", user_path(@user), count:0
		assert_select "a[href=?]", logout_path,      count:0
	end

end
