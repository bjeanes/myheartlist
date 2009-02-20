class HeartsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, :with=> :error_logout
  before_filter :get_user
  protect_from_forgery :except=>:auto_complete_for_heart_name

  auto_complete_for :heart, :name

  def index
    if @user
      @hearts = @user.hearts
      @heart = Heart.new
    else
      @hearts = Heart.all(:order=>"items_count desc, name")
      render :template => 'hearts/all', :layout => true and return
    end
  end
  
  def show
    @heart = Heart.find(params[:id])
  end
  
  def new
    @heart = Heart.new
  end
  
  def create
#    @heart = current_user.hearts.new(params[:heart])
    if current_user.create_heart(params[:heart])
      flash[:notice] = "Successfully created heart."
      redirect_to user_hearts_path(current_user)
    else
      @heart = Heart.new(params[:heart])
      flash[:error] = "Item is already in you heart list"
      render :action => 'new'
    end
  end
  
  def edit
    @heart = Heart.find(params[:id])
  end
  
  def update
    @heart = current_user.hearts.find(params[:id])
    if @heart.update_attributes(params[:heart])
      flash[:notice] = "Successfully updated heart."
      redirect_to @heart
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @heart = current_user.hearts.find(params[:id])
    @heart.destroy
    flash[:notice] = "Successfully destroyed heart."
    redirect_to hearts_url
  end

  def sort
    return unless @user
    params['my-hearts'].each_with_index do |id, index|
      Item.update_all(['position = ?', index + 1], ['heart_id = ? AND user_id = ?', id, @user.id])
    end
    render :nothing => true
  end

  private
  def get_user
    @user = User.find_id_or_username(params[:user_id]) if params[:user_id]
  end
end
