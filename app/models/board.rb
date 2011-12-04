# **Board** represents a whiteboard, either public (no password)
# or private.
class Board < ActiveRecord::Base

  # A board has many texts on it.
  has_many :texts

  # A field for creating new private board.
  attr_accessor :password_confirmation

  # Board should has unique name, within 1 to 64 characters
  # in length.
  validates_uniqueness_of :name, case_sensitive: false
  validates_length_of :name, within: 1..64
  validates_format_of :name, with: /\A[a-z_]*\z/i
  validates_confirmation_of :password

  # Constants for range of acceptable query requests.
  READ_HEIGHT_RANGE = 1..300
  READ_WIDTH_RANGE = 1..400

  # Try to login a board.
  def self.login(name, password)
    board = find_by_name(name)
    if board and board.password == password
      # Return logged in board.
      board
    else
      # Return nil means failed.
      nil
    end
  end

  def to_param
    name || id
  end

  def read(row, col, height, width, last_modified = nil)
    # Rreject width, height outside the range limit.
    return unless READ_WIDTH_RANGE.include? width.to_i and READ_HEIGHT_RANGE.include? height.to_i

    # Return texts within query range.
    if last_modified
      Text.where('texts.board_id = ? AND texts.row >= ? AND texts.row < ? ' +
                 'AND texts.left < ? AND texts.right >= ? AND texts.updated_at >= ?',
                 id.to_i, row.to_i, row.to_i + height.to_i,
                 col.to_i + width.to_i, col.to_i, last_modified)
    else
      Text.where('texts.board_id = ? AND texts.row >= ? AND texts.row < ? ' +
                 'AND texts.left < ? AND texts.right >= ?',
                 id.to_i, row.to_i, row.to_i + height.to_i,
                 col.to_i + width.to_i, col.to_i)
    end
  end
end
##### Schema Information

# Table name: boards
#
#      id         :integer         not null, primary key
#      name       :string(255)
#      password   :string(255)
#      created_at :datetime
#      updated_at :datetime
#

