module ProductGroupSearch
  class DateField < NumberField
    def coerced_value
      Date.strptime(value.try(:to_s), "%d/%m/%Y")
    end

    def valid_value_data_type?
      begin
        Date.strptime(value.try(:to_s), "%d/%m/%Y")
        true
      rescue
        false
      end
    end
  end
end
