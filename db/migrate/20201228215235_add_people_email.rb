class AddPeopleEmail < ActiveRecord::Migration
  def change
    add_column :people, :email, :string
  end
end
