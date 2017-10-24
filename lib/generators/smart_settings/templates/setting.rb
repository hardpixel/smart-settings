class <%= setting_class %>Settings < SmartSettings::Base
  <%- setting_fields.each do |field| -%>
  setting <%= field %>
  <%- end -%>
end
