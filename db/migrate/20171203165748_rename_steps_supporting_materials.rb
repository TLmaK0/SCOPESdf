class RenameStepsSupportingMaterials < ActiveRecord::Migration[5.0]
  def change
    rename_column :steps, :supporting_materials, :design_files
  end
end
