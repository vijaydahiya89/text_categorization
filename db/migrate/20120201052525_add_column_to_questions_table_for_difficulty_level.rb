class AddColumnToQuestionsTableForDifficultyLevel < ActiveRecord::Migration
  def change
    add_column :questions, :difficulty_level, :string
  end
end
