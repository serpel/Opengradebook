class BiweeklySubjectGrade < ActiveRecord::Base
  belongs_to :student
  belongs_to :subject

  def total
    (self.w1.to_f + self.w2.to_f + self.w3.to_f + self.w4.to_f)/4
  end
end
