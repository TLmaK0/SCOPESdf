class CreateGenericTag < ActiveRecord::Migration[5.0]
  def change
    create_table :generic_tags , id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
    end
  end
end
