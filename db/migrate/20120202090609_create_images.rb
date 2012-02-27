class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :path
      t.integer :question_id
      t.integer :answer_id

      t.timestamps
    end
  end
end
