class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.integer :rid
      t.timestamps
    end
  end
end
