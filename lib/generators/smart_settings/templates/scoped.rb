class CreateScopedSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :scoped_settings do |t|
      t.string     :var,      null: false
      t.string     :value
      t.references :settable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :scoped_settings, [:settable_id, :settable_type, :var], unique: true
  end
end
