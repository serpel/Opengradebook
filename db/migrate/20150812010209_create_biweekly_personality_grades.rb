class CreateBiweeklyPersonalityGrades < ActiveRecord::Migration
  def self.up
    create_table :biweekly_personality_grades do |t|
      t.integer :student_id
      t.integer :student_additional_grade_field_id
      t.string :w1
      t.string :w2
      t.string :w3
      t.string :w4
      t.integer :period

      t.timestamps
    end
  end

  def self.down
    drop_table :biweekly_personality_grades
  end
end
