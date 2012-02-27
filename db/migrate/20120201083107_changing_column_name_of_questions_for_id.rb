class ChangingColumnNameOfQuestionsForId < ActiveRecord::Migration
  def up
    rename_column :questions,  :topic , :topic_id
    rename_column :questions,  :sub_topic, :subtopic_id
    rename_column :questions,  :directions, :direction_id
    rename_column :questions,  :positive_mark, :positive_id
    rename_column :questions,  :negative_mark, :negative_id
    rename_column :questions,  :difficulty_level, :difficulty_id
  end

  def down
  end
end
