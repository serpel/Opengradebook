class CreateStudentClassNotesValues < ActiveRecord::Migration
  def self.up
    create_table :student_class_notes_values do |t|
      t.decimal :Value
      t.references :subjects
      t.references :periods

      t.timestamps
    end
  end

  def self.down
    drop_table :student_class_notes_values
  end
end
