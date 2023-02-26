class CreateChurches < ActiveRecord::Migration[4.2]
  def change
    create_table :churches do |t|
      t.integer :position
      t.integer :nth, default: 0
      t.string :prefix, default: "Iglesia Bautista de"
      t.string :name, null: false
      t.string :nickname
      t.string :town
      t.integer :size, default: 0
      t.text :notes

      t.timestamps
    end
  end
end
