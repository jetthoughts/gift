module ProductGroupSearch
  module CustomFieldStrategy
    def join(proxy)
      proxy.join(target_table).on(join_condition)
    end

    def join_condition
      target_table[:product_id].eq(Product.arel_table[:id])
    end

    def target_table
      unless @_target
        @_target =CustomFieldAnswer.arel_table.alias("answers#{index}")
      end
      @_target
    end

    def custom_field
      @_custom_field ||= CustomField.find(self.name)
    end

    def query_column
      field_type = custom_field.field_type
      if field_type == 'text'
        :value
      else
        "#{field_type}_value".to_sym
      end
    end

    def field_type
      custom_field.field_type
    end

    def localized_name
      custom_field.name
    end
  end
end
