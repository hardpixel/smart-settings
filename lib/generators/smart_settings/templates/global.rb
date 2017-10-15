class CreateGlobalSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :global_settings do |t|
      t.string :var,   null: false
      t.string :value
      t.string :group, null: false

      t.timestamps
    end

    add_index :global_settings, [:group, :var], unique: true
  end
end
