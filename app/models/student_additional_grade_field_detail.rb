class StudentAdditionalGradeFieldDetail < ActiveRecord::Base
  belongs_to :student
  belongs_to :batch
  belongs_to :student_additional_grade_field
end
