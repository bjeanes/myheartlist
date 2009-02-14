require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      User.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
  
    should "redirect when model is valid" do
      User.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to root_url
      assert_equal assigns['user'].id, session['user_id']
    end
  end

  context "index action" do
    setup do
      @user1 = users(:user_1)
    end
    should "redirect to users hearts" do
      get :index, :user_id=>@user1
      assert_redirected_to user_hearts_path(@user1)
    end
    should "redirect to global hearts if invalid user" do
      get :index, :user_id=>User.last.id+1
      assert_redirected_to hearts_path
    end
    should "redirect to global hearts when no user" do
      get :index
      assert_redirected_to hearts_path
    end
  end

end
