module ProductGroupSearch
  class NumberField < BaseField
    delegate :eq, :lt, :gt, :lteq, :gteq, to: :query_field

    def valid_value_data_type?
      value && value.to_s.try(:match, /\A[+-]?\d+?(\.\d+)?\Z/).present?
    end

    def coerced_value
      value.try(:to_f)
    end

    def valid_operators
      %w(eq lt gt lteq gteq)
    end
  end
end
