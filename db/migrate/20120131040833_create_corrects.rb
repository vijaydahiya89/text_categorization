class CreateCorrects < ActiveRecord::Migration
  def change
    create_table :corrects do |t|
      t.string :status

      t.timestamps
    end
  end
end
