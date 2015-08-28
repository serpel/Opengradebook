class BiweeklySubjectGrade < ActiveRecord::Base
  belongs_to :student
  belongs_to :subject

  def total
    (self.w1.to_f + self.w2.to_f + self.w3.to_f + self.w4.to_f)/4
  end

  def week(number)
    case number
      when 1 then self.w1.to_f
      when 2 then self.w2.to_f
      when 3 then self.w3.to_f
      when 4 then self.w4.to_f
      else 0
    end
  end
end
