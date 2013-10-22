class AddSchoolIdToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :school_id, :integer
  end

  def self.down
    remove_column :students, :school_id
  end
end
