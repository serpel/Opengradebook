class AddSchoolRefToEmployeeDepartments < ActiveRecord::Migration
  def self.up
    add_column :employee_departments, :school_id, :integer, :references=>"schools"
  end

  def self.down
    remove_column :employee_departments, :school_id
  end
end
