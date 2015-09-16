class CreateBiweeklySubjectGrades < ActiveRecord::Migration
  def self.up
    create_table :biweekly_subject_grades do |t|
      t.integer :student_id
      t.integer :subject_id
      t.integer :w1
      t.integer :w2
      t.integer :w3
      t.integer :w4
      t.integer :period

      t.timestamps
    end
  end

  def self.down
    drop_table :biweekly_subject_grades
  end
end
