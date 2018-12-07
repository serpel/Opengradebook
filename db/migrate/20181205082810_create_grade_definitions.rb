class CreateGradeDefinitions < ActiveRecord::Migration
  def self.up
    create_table :grade_definitions do |t|
      t.string :Name
      t.integer :OrderNumber

      t.timestamps
    end
  end

  def self.down
    drop_table :grade_definitions
  end
end
