class School < ActiveRecord::Base

  has_many :course, :dependent => :destroy
  named_scope :deleted, :conditions => { :is_deleted => true }, :order => 'school_name asc'

  #TODO: editar los usuarios asignados a cursos
  def empty_school
    course.find_all_by_school_id(self.id).each do |i|

      #update atributo if not want to delete the register
      #s.update_attribute(:school_id,nil)
      i.update_attributes(:is_deleted=>true)
    end    
  end
  
end
