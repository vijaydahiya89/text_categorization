require 'test_helper'

class CorrectsControllerTest < ActionController::TestCase
  setup do
    @correct = corrects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:corrects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create correct" do
    assert_difference('Correct.count') do
      post :create, correct: @correct.attributes
    end

    assert_redirected_to correct_path(assigns(:correct))
  end

  test "should show correct" do
    get :show, id: @correct.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @correct.to_param
    assert_response :success
  end

  test "should update correct" do
    put :update, id: @correct.to_param, correct: @correct.attributes
    assert_redirected_to correct_path(assigns(:correct))
  end

  test "should destroy correct" do
    assert_difference('Correct.count', -1) do
      delete :destroy, id: @correct.to_param
    end

    assert_redirected_to corrects_path
  end
end
