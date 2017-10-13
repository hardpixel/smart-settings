class Create<%= template.capitalize %>Settings < ActiveRecord::Migration[5.0]
  def change
    create_table :<%= template %>_settings do |t|
      t.string   :var
      t.string   :value
      <%- if template == 'global' -%>
      t.string   :group
      <%- else -%>
      t.integer  :settable_id
      t.string   :settable_type
      <%- end -%>

      t.timestamps
    end

    <%- if template == 'global' -%>
    add_index :global_settings, [:group, :var], unique: true
    <%- else -%>
    add_index :scoped_settings, [:settable_id, :settable_type, :var], unique: true
    <%- end -%>
  end
end
