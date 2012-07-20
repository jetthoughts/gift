module ProductGroupSearch
  class TextField < BaseField
    delegate :matches, to: :query_field

    def contains(val)
      matches("%#{val}%")
    end

    def ends(val)
      matches("%#{val}")
    end

    def starts(val)
      matches("#{val}%")
    end

    def eq(val)
      matches(val)
    end

    def valid_operators
      %w(eq contains starts ends)
    end

    def coerced_value
      value.try(:to_s)
    end

    def valid_value_data_type?
      condition.value.present?
    end
  end
end
