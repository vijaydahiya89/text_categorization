class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :topic

      t.timestamps
    end
  end
end
