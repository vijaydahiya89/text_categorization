class DropCorrectsTableAndProductionsTable < ActiveRecord::Migration
  def up
    drop_table :products
    drop_table :corrects
  end

  def down
  end
end
