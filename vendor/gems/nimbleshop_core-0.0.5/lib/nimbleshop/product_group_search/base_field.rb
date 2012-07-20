module ProductGroupSearch
  class BaseField
    attr_accessor :condition
    delegate :query_field, :value, to: :condition

    def initialize(condition)
      self.condition = condition
    end

    def valid_operator?(operator)
      valid_operators.include?(operator.to_s)
    end

    def where(proxy = nil)
      clause = send(condition.operator, coerced_value)
      proxy ? proxy.and(clause) : clause
    end
  end
end
