class CreateStudentAdditionalGradeFields < ActiveRecord::Migration
  def self.up
    create_table :student_additional_grade_fields do |t|
      t.string :name
      t.references :school

      t.timestamps
    end
  end

  def self.down
    drop_table :student_additional_grade_fields
  end
end
