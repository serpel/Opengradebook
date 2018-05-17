class AddOrderToSubjects < ActiveRecord::Migration
  def self.up
    add_column :subjects, :order, :integer
  end

  def self.down
    remove_column :subjects, :order
  end
end
