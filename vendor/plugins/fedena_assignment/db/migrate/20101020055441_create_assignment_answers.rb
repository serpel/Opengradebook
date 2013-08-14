class CreateAssignmentAnswers < ActiveRecord::Migration
  def self.up
    create_table :assignment_answers do |t|
      t.references :assignment
      t.references :student
      t.string :status ,:default=>0
      t.string :title
      t.text :content
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_answers
  end
end
