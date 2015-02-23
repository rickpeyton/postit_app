class SessionsController < ApplicationController
  before_action :set_user, only: [:create]

  def new; end

  def create
    if @user && @user.authenticate(params[:password])
      check_for_two_factor
    else
      flash[:error] = 'That username and password combination is invalid'
      render :new
    end
  end

  def twofactor
    @user = User.find_by(username: session[:username])
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have successfully logged out'
    redirect_to root_path
  end

  private

    def set_user
      @user = User.find_by(username: params[:username])
    end

    def check_for_two_factor
      if @user.two_factor > 0
        generate_twofactor_code!
        session[:username] = @user.username
        redirect_to twofactor_path
      else
        session[:user_id] = @user.id
        flash[:notice] = 'You have logged in successfully'
        redirect_to root_path
      end
    end

    def generate_twofactor_code!
      @user.update(pin: rand(10 ** 5).to_s)
    end
end
