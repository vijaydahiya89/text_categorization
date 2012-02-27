class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :question
      t.string :option_1
      t.string :option_2
      t.string :option_3
      t.string :option_4
      t.string :correct_option

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
