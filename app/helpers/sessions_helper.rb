module SessionsHelper

	#Log in a user
	def log_in(user)
		session[:user_id] = user.id
		# Guard against session replay attacks.
    	# See https://bit.ly/33UvK0w for more.
		session[:session_token] = user.session_token
	end

	#Remembers a user permanently
	def remember(user)
		user.remember
		cookies.permanent.encrypted[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token	
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

		# if user_id = session[:user_id]
		# 	@current_user ||= User.find_by(id: session[:user_id])
		# elsif user_id = cookies.encrypted[:user_id]
		# 	user = User.find_by(id: user_id)
		# 	if user && user.authenticated?(cookies[:remember_token])
		# 		log_in user
		# 		@current_user = user
		# 	end
		# end

		# if session[:user_id]
		# 	user_id = session[:user_id]
		# 	@current_user ||= User.find_by(id: session[:user_id])
		# elsif cookies.encrypted[:user_id]
		# 	 # The tests still pass, so this branch is currently untested.
		# 	user_id = cookies.encrypted[:user_id]
		# 	user = User.find_by(id: user_id)
		# 	if user && user.authenticated?(cookies[:remember_token])
		# 		log_in user
		# 		@current_user = user
		# 	end
		# end

		if (user_id = session[:user_id])
			user = User.find_by(id: user_id)
			if user && session[:session_token] == user.session_token
				@current_user = user
			end
		elsif (user_id = cookies.encrypted[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in(user)
				@current_user = user
			end
			
		end

	end

	#Check whether a user is logged in
	def logged_in?
		!current_user.nil?
		
	end

	def forget(user)
	    user.forget
	    cookies.delete(:user_id)
	    cookies.delete(:remember_token)
  	end

	def log_out
		#session.delete(:user_id)
		#session[:user_id] = nil
		forget(current_user)
		#reset_session
		session.delete(:user_id)
		session[:user_id] = nil
		@current_user = nil
	end

end
