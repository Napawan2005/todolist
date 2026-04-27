class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :university

      t.timestamps
    end
  end
end
