class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.string :password

      t.timestamps
    end

    change_table :boards do |t|
      t.index :name
    end
  end
end
