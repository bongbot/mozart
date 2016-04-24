require 'test_helper'

class SassControllerTest < ActionController::TestCase
  setup do
    @sass = sasses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sass)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sass" do
    assert_difference('Sass.count') do
      post :create, sass: {  }
    end

    assert_redirected_to sass_path(assigns(:sass))
  end

  test "should show sass" do
    get :show, id: @sass
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sass
    assert_response :success
  end

  test "should update sass" do
    patch :update, id: @sass, sass: {  }
    assert_redirected_to sass_path(assigns(:sass))
  end

  test "should destroy sass" do
    assert_difference('Sass.count', -1) do
      delete :destroy, id: @sass
    end

    assert_redirected_to sasses_path
  end
end
