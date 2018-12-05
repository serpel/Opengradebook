class CreateStudentClassNotes < ActiveRecord::Migration
  def self.up
    create_table :student_class_notes do |t|
      t.integer :OrderNumber
      t.string :Name
      t.decimal :Value
      t.references :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :student_class_notes
  end
end
