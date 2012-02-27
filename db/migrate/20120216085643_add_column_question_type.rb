class AddColumnQuestionType < ActiveRecord::Migration
  def up
     add_column :questions, :question_type, :string
  end

  def down
  end
end
