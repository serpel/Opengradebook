class Grade < ActiveRecord::Base
  belongs_to :Period
  belongs_to :Subject
  belongs_to :GradeDefinition
end
