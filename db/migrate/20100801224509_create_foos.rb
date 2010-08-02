class CreateFoos < ActiveRecord::Migration
  def self.up
    create_table :foos do |t|
      t.string :name
      t.boolean :active
      t.string :style
      t.datetime :due_date
      t.string :country
      t.timestamps
    end
  end

  def self.down
    drop_table :foos
  end
end
