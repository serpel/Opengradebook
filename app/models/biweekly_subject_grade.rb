class BiweeklySubjectGrade < ActiveRecord::Base
  belongs_to :student

  def total
    (self.w1.to_f + self.w2.to_f + self.w3.to_f + self.w4.to_f)/4
  end
end
