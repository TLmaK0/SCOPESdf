class AddColumnsToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :fabrication_equipment, :string, array: true, default: []
    add_column :steps, :name, :string
  end
end
