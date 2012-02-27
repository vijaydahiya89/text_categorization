class AddQuestionIdToCorrects < ActiveRecord::Migration
  def change
    add_column :corrects, :question_id, :integer
  end
end
