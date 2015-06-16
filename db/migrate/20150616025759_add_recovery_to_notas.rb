class AddRecoveryToNotas < ActiveRecord::Migration
  def self.up
    add_column :notas, :recovery, :integer
  end

  def self.down
    remove_column :notas, :recovery
  end
end
