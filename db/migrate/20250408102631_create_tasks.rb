class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.references :parent, foreign_key: { to_table: :tasks }, index: true, null: true
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
