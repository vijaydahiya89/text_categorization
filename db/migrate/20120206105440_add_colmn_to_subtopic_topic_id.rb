class AddColmnToSubtopicTopicId < ActiveRecord::Migration
  def change
    add_column :subtopics, :topic_id, :integer
  end
end
