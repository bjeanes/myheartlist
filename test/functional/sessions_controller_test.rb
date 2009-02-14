require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when authentication is invalid" do
      User.stubs(:authenticate).returns(nil)
      post :create
      assert_template 'new'
      assert_nil session['user_id']
    end
    
    should "redirect when authentication is valid" do
      user = User.first
      User.stubs(:authenticate).returns(user)
      post :create
      assert_redirected_to user_hearts_path(user)
      assert_equal user.id, session['user_id']
    end
  end
end
