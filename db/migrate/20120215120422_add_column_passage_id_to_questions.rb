class AddColumnPassageIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :passage_id, :integer
    rename_column :questions,  :direction_id , :direction
  end
end
