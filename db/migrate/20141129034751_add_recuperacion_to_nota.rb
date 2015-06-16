class AddRecuperacionToNota < ActiveRecord::Migration
  def self.up
    add_column :notas, :recuperacion_1, :integer
    add_column :notas, :recuperacion_2, :integer
    add_column :notas, :recuperacion_3, :integer
    add_column :notas, :recuperacion_4, :integer
  end

  def self.down
    remove_column :notas, :recuperacion_4
    remove_column :notas, :recuperacion_3
    remove_column :notas, :recuperacion_2
    remove_column :notas, :recuperacion_1
  end
end
