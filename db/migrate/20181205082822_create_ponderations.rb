class CreatePonderations < ActiveRecord::Migration
  def self.up
    create_table :ponderations do |t|
      t.string :Name
      t.decimal :Value
      t.references :Subject
      t.references :GradeDefinition

      t.timestamps
    end
  end

  def self.down
    drop_table :ponderations
  end
end
