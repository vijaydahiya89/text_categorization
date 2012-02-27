class Question < ActiveRecord::Base
  has_many :answers
  has_one :image
  belongs_to :subtopic
  belongs_to :topic
  belongs_to :passage
  belongs_to :question_bank
end
