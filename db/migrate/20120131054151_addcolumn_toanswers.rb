class AddcolumnToanswers < ActiveRecord::Migration
  def up
    add_column :answers, :status, :string , :default =>  "wrong"
  end

  def down
  end
end
