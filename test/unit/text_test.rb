require 'test_helper'

class TextTest < ActiveSupport::TestCase
  setup :create_public_board

  def create_public_board
    @board = Board.create!(name: 'public', password: '')
    Text.destroy_all
  end

  test "insert invalid text" do
    # missing board
    assert(!Text.new(content: 'xxx', left: 1, row: 1).valid?)
    # missing content
    assert(!Text.new(board: @board, left: 1, row: 1).valid?)
    # empty content
    assert(!Text.new(board: @board, content: '', left: 1, row: 1).valid?)
    # too long content
    assert(!Text.new(board: @board, content: 'xyz' * 1000, left: 1, row: 1).valid?)
    # missing row
    assert(!Text.new(board: @board, content: 'xyz', left: 1).valid?)
    # missing left
    assert(!Text.new(board: @board, content: 'xyz', right: 1, row: 1).valid?)
  end

  test "insert valid text" do
    assert_difference('Text.count', 1) do
      assert(Text.create(board: @board, content: 'xyz', left: 1, row: 1).valid?)
    end
  end

  test "insert empty text" do
    assert_no_difference('Text.count') do
      Text.create(board: @board, content: '    ', left: 3, row: 3)
    end
  end

  test "correct right value" do
    content = 'hello'
    t = Text.create!(board: @board, content: content, left: 1, row: 1)
    assert_equal t.right, t.left + content.length - 1
  end

  test "erase from left" do
    assert_difference('Text.count', 1) do
      Text.create!(board: @board, content: 'abc', left: 1, row: 1)
    end

    assert_difference('Text.count', -1) do
      Text.create(board: @board, content: '    ', left: 0, row: 1)
    end
  end

  test "erase entire text from right" do
    assert_difference('Text.count', 1) do
      Text.create!(board: @board, content: 'abc', left: 1, row: 1)
    end

    assert_difference('Text.count', -1) do
      Text.create(board: @board, content: '   ', left: 1, row: 1)
    end
  end

  test "erase entire text using 3 chars" do
    assert_difference('Text.count', 1) do
      Text.create!(board: @board, content: 'abc', left: 1, row: 1)
    end

    assert_difference('Text.count', -1) do
      (1..3).each do |t|
        Text.create(board: @board, content: ' ', left: t, row: 1)
      end
    end
  end

  test "erase left text" do
    Text.create!(board: @board, content: 'abc', left: 1, row: 1)

    assert_no_difference('Text.count') do
      Text.create(board: @board, content: '  ', left: 0, row: 1)
    end

    t = Text.where(left: 2, row:1, board_id: @board).first
    assert_equal 'bc', t.content
  end

  test "erase right text" do
    Text.create!(board: @board, content: 'abc', left: 1, row: 1)

    assert_no_difference('Text.count') do
      Text.create(board: @board, content: '  ', left: 2, row: 1)
    end

    t = Text.where(left: 1, row:1, board_id: @board).first
    assert_equal 'a', t.content
  end


  test "correctly split" do
    Text.create!(board: @board, content: 'abc', left: 1, row: 1)

    assert_difference('Text.count', 1) do
      Text.create(board: @board, content: ' ', left: 2, row: 1)
    end

    assert_equal 'a', Text.where(left:1, row:1, board_id: @board).first.content
    assert_equal 'c', Text.where(left:3, row:1, board_id: @board).first.content
  end

  test "correctly merge" do
    Text.create!(board: @board, content: 'abc', left: 15, row: 4)

    assert_no_difference('Text.count') do
      Text.create(board: @board, content: 'abc', left: 15, row: 4)
      # Text.create(board: @board, content: 'ab', left: 15, row: 4)
      # Text.create(board: @board, content: 'bc', left: 16, row: 4)
    end

    assert_equal Text.where(left:15, row:4, board_id: @board).first.content, 'abc'
  end

  test "insert blank text" do
    Text.create!(board: @board, content: 'abc', left: 3, row: 4)

    assert_no_difference('Text.count') do
      Text.create(board: @board, content: ' ', left: 15, row: 4)
      Text.create(board: @board, content: '  ', left: 14, row: 4)
      Text.create(board: @board, content: '  ', left: 16, row: 4)
    end
  end

  test "smart merge adjacent texts" do
    Text.create!(board: @board, content: 'abc', left: 3, row: 4)
    Text.create!(board: @board, content: 'def', left: 9, row: 4)

    assert_difference('Text.count', -1) do
      Text.create(board: @board, content: 'ins', left: 6, row: 4)
      puts Text.all
    end

    assert_equal \
      'abcinsdef',
      @board.texts.where(left:3, row:4, board_id: @board).first.content
  end

end
# == Schema Information
#
# Table name: texts
#
#  id         :integer         not null, primary key
#  board_id   :integer
#  row        :integer
#  left       :integer
#  right      :integer
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

