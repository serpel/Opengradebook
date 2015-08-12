class CreateStudentAdditionalGradeFieldDetails < ActiveRecord::Migration
  def self.up
    create_table :student_additional_grade_field_details do |t|
      t.references :student
      t.references :batch
      t.references :student_additional_grade_field
      t.integer :period
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :student_additional_grade_field_details
  end
end
