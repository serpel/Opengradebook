class AddSchoolIdToAssignments < ActiveRecord::Migration
  def self.up
    [:assignments,:assignment_answers].each do |c|
      add_column c,:school_id,:integer
      add_index c,:school_id
    end    
  end

  def self.down
    [:assignments,:assignment_answers].each do |c|
      remove_index c,:school_id
      remove_column c,:school_id
    end
  end
end
