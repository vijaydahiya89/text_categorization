require 'test_helper'

class QuestionBanksControllerTest < ActionController::TestCase
  setup do
    @question_bank = question_banks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:question_banks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create question_bank" do
    assert_difference('QuestionBank.count') do
      post :create, question_bank: @question_bank.attributes
    end

    assert_redirected_to question_bank_path(assigns(:question_bank))
  end

  test "should show question_bank" do
    get :show, id: @question_bank.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @question_bank.to_param
    assert_response :success
  end

  test "should update question_bank" do
    put :update, id: @question_bank.to_param, question_bank: @question_bank.attributes
    assert_redirected_to question_bank_path(assigns(:question_bank))
  end

  test "should destroy question_bank" do
    assert_difference('QuestionBank.count', -1) do
      delete :destroy, id: @question_bank.to_param
    end

    assert_redirected_to question_banks_path
  end
end
