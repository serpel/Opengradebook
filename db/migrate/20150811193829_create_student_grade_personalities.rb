class CreateStudentGradePersonalities < ActiveRecord::Migration
  def self.up
    create_table :student_grade_personalities do |t|
      t.integer :student_additional_grade_field_id
      t.integer :student_id
      t.string :p1
      t.string :p2
      t.string :p3
      t.string :p4
      t.timestamps
    end
  end

  def self.down
    drop_table :student_grade_personalities
  end
end
