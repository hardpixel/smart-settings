module SmartSettings
  module NoTable
    extend ActiveSupport::Concern

    class SchemaCache
      def columns_hash(table_name); {} end
      def data_source_exists?(table_name); false end
      def clear_data_source_cache!(table_name); true end
    end

    class Connection < ActiveRecord::ConnectionAdapters::AbstractAdapter
      def initialize(*)
        super
        @schema_cache = SchemaCache.new
      end
    end

    module ClassMethods
      def connection
        @connection ||= Connection.new nil
      end

      def destroy(*); new.destroy end
      def destroy_all(*); [] end
      def find_by_sql(*); [] end
    end

    def reload(options = nil)
      @attributes = self.class.new.instance_variable_get("@attributes")
      @new_record = false
      self
    end

    def update(attributes)
      _run_update_callbacks do
        assign_attributes(attributes)
        save
      end
    end

    def destroy
      _run_destroy_callbacks do
        @_trigger_destroy_callback = true
        @destroyed = true
        freeze
      end
    end

    private

      def _create_record(*)
        _run_create_callbacks do
          @new_record = false
          true
        end
      end

      def _update_record(*)
        _run_update_callbacks do
          @_trigger_update_callback = true
          true
        end
      end
  end
end
