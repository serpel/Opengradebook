class AddRecovery2ToNotas < ActiveRecord::Migration
  def self.up
    add_column :notas, :recovery2, :integer
  end

  def self.down
    remove_column :notas, :recovery2
  end
end
