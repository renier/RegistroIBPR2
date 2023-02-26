class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.integer :salutation
      t.string :name, null: false
      t.string :lastnames, null: false
      t.boolean :sex, null: false
      t.integer :role, null: false
      t.text :description
      t.boolean :attended, default: false
      t.boolean :print, default: true
      t.boolean :materials, default: false
      t.references :church, index: true

      t.timestamps
    end
  end
end
