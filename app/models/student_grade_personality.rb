class StudentGradePersonality < ActiveRecord::Base
  belongs_to :student_additional_grade_field
  belongs_to :student
end
