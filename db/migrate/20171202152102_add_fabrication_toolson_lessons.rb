class AddFabricationToolsonLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :fabrication_tools, :string, array: true, default: []
  end
end
