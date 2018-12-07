class Ponderation < ActiveRecord::Base
  belongs_to :GradeDefinition
  belongs_to :Subject
end
