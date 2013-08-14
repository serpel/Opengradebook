
class EmployeeDepartment < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :code
  has_many :employees
  has_many  :employee_department_events
  has_many  :events,  :through=>:employee_department_events
  named_scope :active, :conditions => {:status => true }

  def self.department_by_school(school_id)
    tmp = []
   #  self.employees.each do |s|
#      if s.id.eql? school_id
#         if !tmp.include?(s)
#            tmp.push s
#         end
#      end
       #tmp.push s
    #end
    tmp
  end

  def test
    return 1
  end

  def self.department_total_salary(start_date,end_date)
    total = 0
    self.employees.each do |e|
      salary_dates = e.all_salaries(start_date,end_date)
      salary_dates.each do |s|
        total += e.employee_salary(s.salary_date.to_date)
      end
    end
    total
  end

end