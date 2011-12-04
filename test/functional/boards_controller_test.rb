require 'test_helper'

class BoardsControllerTest < ActionController::TestCase

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:board)
  end

  test 'should get login' do
    get :login
    assert_response :success
  end

  test 'should create board' do
    assert_difference('Board.count', 1) do
      post :create, board: { 
        name: 'bla', 
        password: 'bla',
        password_confirmation: 'bla'
      }
    end

    assert_redirected_to board_path(assigns(:board))
  end

end
