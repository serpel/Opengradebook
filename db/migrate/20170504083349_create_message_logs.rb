class CreateMessageLogs < ActiveRecord::Migration
  def self.up
    create_table :message_logs do |t|
      t.references :employee
      t.string  "subject"
      t.string  "body"
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :message_logs
  end
end
