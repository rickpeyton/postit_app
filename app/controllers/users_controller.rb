class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def show; end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by(slug: params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'New account successfully created'
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Your profile was edited'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def require_same_user
    if current_user != @user
      flash[:error] = 'You are not allowed to do that.'
      redirect_to root_path
    end
  end
end
