class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'You have logged in successfully'
      redirect_to root_path
    else
      flash[:error] = 'That username and password combination is invalid'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have successfully logged out'
    redirect_to root_path
  end
end
