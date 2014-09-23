class StudentGeneralDetail < ActiveRecord::Base

  belongs_to :student
  belongs_to :course

  validates_presence_of :student_id, :batch_id, :period
  validates_numericality_of  :period, :student_id, :batch_id, :greater_than_or_equal_to => 0
end
