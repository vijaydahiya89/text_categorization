class AddColumnBankIdToQuestionsTable < ActiveRecord::Migration
  def change
    add_column :questions, :questionbank_id, :integer , :default =>  "0"
  end
end
