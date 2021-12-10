module SessionsHelper

	#Log in a user
	def log_in(user)
		session[:user_id] = user.id
	end

	#Set logged in user as current user
	def current_user
		#The implementation below will hit the database everytime we use the current_user method
		# if session[:user_id]
		# 	User.find_by(id: session[:user_id])
		# end

		#So we use an instance variable so that database is hit only for the first time
		# if @current_user.nil?
		# 	@current_user = User.find_by(id: session[:user_id])
		# else
		# 	@current_user
		# end

		#Above implementation could be done in more Ruby way
		#@current_user = @current_user || User.find_by(id: session[:user_id])

		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		end
	end

	#Check whether a user is logged in
	def logged_in?
		!current_user.nil?
		
	end

	def log_out
		#session.delete(:user_id)
		#session[:user_id] = nil
		reset_session
		@current_user = nil
	end

end
