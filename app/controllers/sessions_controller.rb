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
    if session[:username].present?
      @user = User.find_by(username: session[:username])
    else
      access_denied
    end

    if request.post?
      reset_session
      if params[:pin] == @user.pin
        @user.update pin: nil
        complete_login
      else
        flash[:error] = 'Pin is incorrect. Please log in again'
        @user.update pin: nil
        redirect_to login_path
      end
    end
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
        complete_login
      end
    end

    def complete_login
      session[:user_id] = @user.id
      flash[:notice] = 'You have logged in successfully'
      redirect_to root_path
    end

    def generate_twofactor_code!
      @user.update(pin: rand(10 ** 5).to_s)
      twillio
    end

    def twillio
      account_sid = ENV['TWILLIO_SID']
      auth_token = ENV['TWILLIO_TOKEN']
      @client = Twilio::REST::Client.new account_sid, auth_token
      @client.account.messages.create({
        :from => '+14804852779',
        :to => @user.phone,
        :body => "#{@user.username}, Your Postit login pin is #{@user.pin}",
      })
    end
end
