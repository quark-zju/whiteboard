class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.references :board
      t.integer :row
      t.integer :left
      t.integer :right
      t.string :content

      t.timestamps
    end
    
    change_table :texts do |t|
      t.index [ :board_id, :row ]
      t.index [ :board_id, :row, :left ]
      t.index [ :board_id, :row, :right ]
      t.index [ :board_id, :row, :left, :updated_at ]
      t.index [ :board_id, :row, :right, :updated_at ]
    end
  end
end
