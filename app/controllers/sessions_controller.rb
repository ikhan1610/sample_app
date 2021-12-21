class SessionsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email])
  	if !!@user && @user.authenticate(params[:session][:password])
  		#reset_session #Resolves the "Session Fixation" attack.
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  		log_in @user
  		flash[:success] = 'Logged in successfully. Welcome to the Sample App!!'
  		redirect_to @user
  	else
  		#display error messages and render login page(new.html.erb)
  		flash.now[:danger] = 'Login attemp failed. Wrong E-Mail/Password combination'
  		render 'new'
  	end
  	
  end

  

  def destroy
    # if logged_in?
    # 	log_out 
    #   flash[:success] = "Logged out successfully"
    #   redirect_to root_url
    # end
    log_out if logged_in?
    flash[:success] = "Logged out successfully"
    redirect_to root_url
  end

end
