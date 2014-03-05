class PrintToPrinted < ActiveRecord::Migration
  def change
    change_column :people, :print, :boolean, default: false 
    rename_column :people, :print, :printed

    Person.reset_column_information
    Person.all.each do |p|
      p.update_attribute :printed, !p.printed
    end
  end
end
