# **Text** represents a piece of text at a specified 
# location in a board
class Text < ActiveRecord::Base

  # Disable DEBUG output.
  DEBUG = false

  # A Text is belongs to a board.
  belongs_to :board

  # Class variable, a flag for skipping ActiveRecord callbacks.
  @@skip_callback = false

  # A Text should always have position, board set. Additionally,
  # has a length limit.
  validates_presence_of :board
  validates_presence_of :left, :row
  validates_length_of :content, within: 1..1024

  # Calculate right ( = left + content.length ) before saving
  # Text object to database.
  before_save :calculate_right

  # No *overlap* or *adjacent* texts allowed, 
  # merge or clean them.
  after_save :erase_adjacent, :merge_with_adjacent

  # Name aliases, `col` is `left` and `top` is `row`.
  alias_attribute :col, :left
  alias_attribute :top, :row

  def inspect
    to_s
  end

  def to_s
    # Provides tidy debug output.
    "([#{id}] #{row},#{left},'#{content}')"
  end

  private

  def skip_callback?
    @@skip_callback
  end

  # A wrapper to skip callbacks.
  def skip_callback
    @@skip_callback = true
    result = yield
    @@skip_callback = false
    result
  end

  def calculate_right
    self.right = left + content.length - 1
  end

  # Erase adjacent texts, for example, inserting `   ` (3 spaces)
  # at `D` of Text object:
  #
  #     [ABCDEFGHI]
  #
  # Results in two Text objects:
  #
  #     [ABC]   [GHI]
  #
  def erase_adjacent
    return if skip_callback?

    # Only when content is blank (all spaces),
    # should we erase adjacent texts.
    return if content.present?

    # Locate adjacent Texts.
    board.texts.where("row = ? AND left <= ? AND right >= ?", row, right, left).each do |t|
      # Skip self.
      next if t.id == self.id

      # Save left part, ignore right part.
      if t.left < left
        skip_callback do
          Text.create!(board: board,
                       row: row,
                       left: t.left,
                       content: t.content[0..(left - t.left - 1)]
                      )
        end
      end

      # Save right part, ignore left part.
      if t.right > right
        skip_callback do
          Text.create!(board: board,
                       row: row,
                       left: right + 1,
                       content: t.content[-(t.right - right)..-1]
                      )
        end
      end

      # Remove original Text for it is already splitted.
      t.delete
    end

    # Remove self for self only has spaces.
    self.delete if self.persisted?

    # Return false to prevent `merge_with_adjacent`
    # from being called.

    # This does not trigger a ROLLBACK action. Good. 
    # Because this method is a `after_save` callback,
    # not `before_save`.
    false
  end

  # Merge adjancent/overlapped Texts into one,
  # for example:
  #
  #         [ABCDEFG]    [JKL]
  #      +       [HELLO_WO]
  #      ----------------------------------------
  #      =  [ABCDEHELLO_WOJKL]
  # 
  # This demos 2 Texts add 1 Text becomes 1 Text.
  def merge_with_adjacent
    return if skip_callback?

    # Skip blank text.
    return if content.blank?

    # Since self.content is frozen by Rails but we may
    # modify it, just create and modify a new Text and
    # drop self when necessary.
    #
    # For this to work, a `modified` flag variable is 
    # needed.
    modified = false
    new_text = Text.new(board: board, row: row, left: left, content: content)

    board.texts.where("row = ? AND left <= ? AND right >= ?", row, right + 1, left - 1).each do |t|
      # Skip self.
      next if t.id == self.id

      # Merge with left Text.
      if t.left < left
        puts "MERGE LEFT #{new_text} with #{t}: " if DEBUG
        new_text.content = t.content[0..(left - t.left - 1)] + new_text.content
        new_text.left = t.left
        modified = true
      end

      # Merge with right Text.
      if t.right > right
        puts "MERGE RIGHT #{new_text} with #{t}: " if DEBUG
        new_text.content = new_text.content + t.content[-(t.right - right)..-1]
        new_text.right = t.right
        modified = true
      end

      # The original `t` is merged and useless, remove it.
      t.delete
    end

    # Drop self and save the new Text as said previously.
    if modified
      self.delete
      puts "NEW_TEXT: #{new_text}" if DEBUG
      skip_callback { new_text.save }
    end
  end

end
##### Schema Information
#
# Table name: texts
#
#      id         :integer         not null, primary key
#      board_id   :integer
#      row        :integer
#      left       :integer
#      right      :integer
#      content    :string(255)
#      created_at :datetime
#      updated_at :datetime
#

