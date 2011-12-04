require 'test_helper'

class BoardTest < ActiveSupport::TestCase

  test "create a board" do
    assert_difference('Board.count', 1) do
      assert Board.create(name: 'test', password: 'knock', password_confirmation: 'knock')
    end
  end

  test "password confirmation" do
    assert not(Board.create(name: 'test', password: 'alter', password_confirmation: 'ne').valid?)
  end

  test "duplicated name should not be allowed" do
    assert Board.create(name: 'test', password: 'knock', password_confirmation: 'knock')
    assert not(Board.create(name: 'test', password: 'alter', password_confirmation: 'alter').valid?) 
  end

  test "login with correct passowrd" do
    board = Board.create!(name: 'test', password: 'knock', password_confirmation: 'knock')
    assert board
    assert_equal board, Board.login('test', 'knock')
  end

  test "login wrong board or with incorrect password" do
    board = Board.create!(name: 'test', password: 'knock', password_confirmation: 'knock')
    assert board
    assert_nil Board.login('tset', 'knock')
    assert_nil Board.login('test', 'wrong')
  end

  test "create text" do
    board = Board.create!(name: 'test', password: 'knock', password_confirmation: 'knock')
    assert_difference('board.texts.count', 1) do
      board.texts.create(row: 3, col: 5, content: 'hello world')
    end
  end

  test "read text in range" do
    board = Board.create!(name: 'test', password: 'readtest', password_confirmation: 'readtest')
    assert_equal board.read(1, 1, 100, 100).count, 0 

    board.texts.create(row: 3, col: 5, content: 'hello world')
    assert_equal board.read(1, 1, 100, 100).count, 1
    assert_equal board.read(1, 1, 3, 5).count, 1
    assert_equal board.read(1, 1, 2, 5).to_a.count, 0
    assert_equal board.read(3, 5, 1, 1).count, 1
    assert_equal board.read(3, 4, 1, 1).to_a.count, 0
    assert_equal board.read(2, 15, 2, 1).count, 1
  end

  test "invalid range read" do
    board = Board.create!(name: 'test', password: 'readtest', password_confirmation: 'readtest')
    assert_equal board.read(1, 1, 100, 100).count, 0 

    board.texts.create(row: 3, col: 5, content: 'hello world')
    height, width = Board::READ_HEIGHT_RANGE.to_a.last, Board::READ_WIDTH_RANGE.to_a.last

    # invalid range read
    assert_nil board.read(1, 1, height + 1, width)
    assert_nil board.read(1, 1, height, width + 1)
    assert_nil board.read(1, 1, 0, 1)
    assert_nil board.read(1, 1, 1, -1)
  end

end
# == Schema Information
#
# Table name: boards
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

