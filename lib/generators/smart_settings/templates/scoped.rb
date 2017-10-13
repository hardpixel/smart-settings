class CreateScopedSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :scoped_settings do |t|
      t.string     :var,    null: false
      t.text       :value
      t.references :target, null: false, polymorphic: true

      t.timestamps
    end

    add_index :scoped_settings, [:target_type, :target_id, :var], unique: true
  end
end
