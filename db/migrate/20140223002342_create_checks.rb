class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.integer :number
      t.decimal :amount, precision: 2, null: false
      t.text :description
      t.references :church, index: true, null: false

      t.timestamps
    end
  end
end
