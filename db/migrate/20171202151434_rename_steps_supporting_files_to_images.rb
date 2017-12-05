class RenameStepsSupportingFilesToImages < ActiveRecord::Migration[5.0]
  def change
    rename_column :steps, :supporting_files, :images
  end
end
