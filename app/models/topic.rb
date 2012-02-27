class Topic < ActiveRecord::Base
  has_many :questions
  has_many :subtopics
end
