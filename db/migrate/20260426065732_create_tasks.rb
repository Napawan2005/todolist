class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.date :due_date
      t.boolean :completed

      t.timestamps
    end
  end
end
