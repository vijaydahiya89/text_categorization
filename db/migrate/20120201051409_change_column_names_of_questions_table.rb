class ChangeColumnNamesOfQuestionsTable < ActiveRecord::Migration
  def up
    rename_column :questions, :option_1, :topic
    rename_column :questions, :option_2, :sub_topic
    rename_column :questions, :option_3, :directions
    rename_column :questions, :option_4, :positive_mark
    rename_column :questions, :correct_option, :negative_mark
  end

  def down
  end
end
