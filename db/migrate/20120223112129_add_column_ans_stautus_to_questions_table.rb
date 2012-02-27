class AddColumnAnsStautusToQuestionsTable < ActiveRecord::Migration
  def change
    add_column :questions, :ans_status, :string , :default =>  "no_ans"
  end
end
