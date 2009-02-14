class UsersController < ApplicationController

  def index
    @user = User.find_id_or_username(params[:user_id])
    redirect_to @user ? user_hearts_path(@user) : hearts_path
  end

  def show
    redirect_to user_hearts_path(params[:user_id])
  end

  def new
      @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
end
