class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string  :var, null: false
      t.string  :value
      t.integer :settable_id
      t.string  :settable_type, null: false

      t.timestamps
    end

    add_index :settings, [:settable_id, :settable_type, :var], unique: true
  end
end
