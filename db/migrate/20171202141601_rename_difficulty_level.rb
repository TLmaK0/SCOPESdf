class RenameDifficultyLevel < ActiveRecord::Migration[5.0]
  def change
    rename_table :difficulty_levels, :mastery_levels
  end
end
