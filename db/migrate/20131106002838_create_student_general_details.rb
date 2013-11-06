class CreateStudentGeneralDetails < ActiveRecord::Migration
  def self.up
    create_table :student_general_details do |t|
      t.integer :student_id
      t.integer :batch_id
      t.integer :period
      t.integer :daysAbsent
      t.integer :daysTardy
      t.string :puntuality
      t.string :effort
      t.string :workOrderAndAppearance
      t.string :socialSkills
      t.string :morals
      t.string :conduct
      t.integer :demerit
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :student_general_details
  end
end
