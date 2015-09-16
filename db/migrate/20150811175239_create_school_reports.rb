class CreateSchoolReports < ActiveRecord::Migration
  def self.up
    create_table :school_reports do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :school_reports
  end
end
