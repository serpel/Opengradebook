class Assignment < ActiveRecord::Base
  belongs_to :employee
  belongs_to :subject
  has_many :assignment_answers , :dependent=>:destroy

  validates_presence_of :title, :content,:student_list, :duedate

  has_attached_file :attachment ,
    :path => ":rails_root/public/uploads/assignments/:employee_id/:id/:basename.:extension"

  named_scope :for_student, lambda { |s|{ :conditions => ["FIND_IN_SET(?,student_list)",s],:order=>"duedate asc"} }

  def download_allowed_for user
    return true if user.admin?
    return (user.employee_record.id==self.employee_id) if user.employee?
    return (self.student_list.split(",").include? user.student_record.id.to_s) if user.student?
    return true if user.parent?
    false
  end
end
