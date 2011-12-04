class CreateDefaultBoard < ActiveRecord::Migration
  def up
    Board.create name: 'public', password: '', password_confirmation: ''
  end

  def down
  end
end
