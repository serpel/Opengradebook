class AddBatchRefToNotas < ActiveRecord::Migration
  def self.up
    add_column :notas, :batch_id, :integer, :references => 'Batch'
  end

  def self.down
    remove_column :notas, :batch_id
  end
end
