module ProductGroupSearch
  module Extension
    # This module bring search feature to product_group. This is how it is used in product_group .
    #
    #    class ProductGroup
    #      has_many :product_group_conditions, dependent: :destroy, extend: ProductGroupSearch::Extension
    #      def products
    #        product_group_conditions.search
    #      end
    #    end
    #
    def search
      Product.find_by_sql(to_search_sql)
    end

    def to_search_sql
      set_indexes # custom_field_strategy needs it

      search_proxy = handle_joins
      search_proxy = search_proxy.where(handle_where_conditions)
      search_proxy = filter_on_active(search_proxy)
      search_proxy = search_proxy.project(Arel.sql("products.*"))

      search_proxy.to_sql
    end

    private

    def set_indexes
      each_with_index { | condition, index | condition.index = index }
    end

    def handle_joins
      reduce(Product.arel_table) { | p, condition | condition.join(p) }
    end

    def handle_where_conditions
      reduce(nil) { | p, condition | condition.where(p) }
    end

    def filter_on_active(search)
      search.where(Product.arel_table[:status].eq('active'))
    end

  end
end
