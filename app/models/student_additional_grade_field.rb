class StudentAdditionalGradeField < ActiveRecord::Base
  belongs_to :school
  has_many :student_additional_grade_field_details
end
