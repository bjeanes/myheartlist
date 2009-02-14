require 'test_helper'

class HeartsControllerTest < ActionController::TestCase

  context "Not logged in" do
    setup do
      @user1 = users(:user_1)
      @controller.stubs(:current_user).returns(nil)
    end
    context "index action" do
      should "render global hearts list" do
        get :index
        assert_template 'index'
        assert_equal(Heart.count, assigns(:hearts).length)
        assert_select "a[href*=/hearts/new]", 0
      end
      should "render users heart list" do
        get :index, :user_id=>@user1
        assert_template 'index'
        assert_equal(@user1.hearts.length, assigns(:hearts).length)
        assert_select "a[href*=/hearts/new]", 0
      end
    end
    context "new action" do
      should "redirect to login page" do
        get :new, :user_id=>@user1
        assert_redirected_to login_path
      end
    end
    context "create action" do
      should "redirect to login page" do
        assert_no_difference("Item.count") do
          get :create, :user_id=>@user1
        end
        assert_redirected_to login_path
      end
    end
  end

  context "Logged in" do
    setup do
      @user1 = users(:user_1)
      @user2 = users(:user_2)
      @controller.stubs(:current_user).returns(@user1)
    end
    context "index action" do
      should "render global hearts list" do
        get :index
        assert_template 'index'
        assert_equal(Heart.count, assigns(:hearts).length)
        assert_select "a[href*=/hearts/new]", 0
      end
      should "render users heart list" do
        get :index, :user_id=>@user1
        assert_template 'index'
        assert_equal(@user1.hearts.length, assigns(:hearts).length)
        assert_select "a[href*=/hearts/new]"
      end
      should "render some one elses heart list" do
        get :index, :user_id=>@user2
        assert_template 'index'
        assert_equal(@user2.hearts.length, assigns(:hearts).length)
        assert_select "a[href*=/hearts/new]",0 
      end
    end
    context "new action" do
      should "render new page" do
        get :new, :user_id=>@user1
        assert_template "new"
      end
    end
    context "create action" do
      should "create item fail and return to new" do
        test_name = "memememe"
        User.any_instance.stubs(:create_heart).returns(false)
        get :create, :user_id=>@user1, :heart=>{:name=>test_name}
        assert_template "new"
        assert_select "input[value=#{test_name}]"
      end
      should "create item and render users hearts list" do
        User.any_instance.stubs(:create_heart).returns(true)
        get :create, :user_id=>@user1
        assert_redirected_to user_hearts_path(@user1)
      end
    end

  end
  
  #  context "show action" do
  #    should "render show template" do
  #      get :show, :id => Heart.first
  #      assert_template 'show'
  #    end
  #  end
  #
  #  context "new action" do
  #    should "render new template" do
  #      get :new
  #      assert_template 'new'
  #    end
  #  end
  #
  #  context "create action" do
  #    should "render new template when model is invalid" do
  #      Heart.any_instance.stubs(:valid?).returns(false)
  #      post :create
  #      assert_template 'new'
  #    end
  #
  #    should "redirect when model is valid" do
  #      Heart.any_instance.stubs(:valid?).returns(true)
  #      post :create
  #      assert_redirected_to heart_url(assigns(:heart))
  #    end
  #  end
  #
  #  context "edit action" do
  #    should "render edit template" do
  #      get :edit, :id => Heart.first
  #      assert_template 'edit'
  #    end
  #  end
  #
  #  context "update action" do
  #    should "render edit template when model is invalid" do
  #      Heart.any_instance.stubs(:valid?).returns(false)
  #      put :update, :id => Heart.first
  #      assert_template 'edit'
  #    end
  #
  #    should "redirect when model is valid" do
  #      Heart.any_instance.stubs(:valid?).returns(true)
  #      put :update, :id => Heart.first
  #      assert_redirected_to heart_url(assigns(:heart))
  #    end
  #  end
  #
  #  context "destroy action" do
  #    should "destroy model and redirect to index action" do
  #      heart = Heart.first
  #      delete :destroy, :id => heart
  #      assert_redirected_to hearts_url
  #      assert !Heart.exists?(heart.id)
  #    end
  #  end
end
