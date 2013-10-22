class AddSchoolIdToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :school_id, :integer
  end

  def self.down
    remove_column :employees, :school_id
  end
end
