class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :employee
      t.references :subject
      t.string :student_list
      t.string :title
      t.text :content
      t.datetime :duedate
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
