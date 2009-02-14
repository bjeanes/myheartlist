class UsersController < ApplicationController

  def index
    redirect_to hearts_path
  end

  def show
    @user = User.find_id_or_username(params[:id])
    redirect_to @user ? user_hearts_path(@user) : hearts_path
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
