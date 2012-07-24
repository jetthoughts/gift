module Kaminari::ActionViewExtension
  def paginate_without_scope options = {}, &block
    paginator = Kaminari::Helpers::Paginator.new self, options.reverse_merge(
      current_page: options[:current_page].to_i,
      num_pages:  options[:total_pages].to_i, 
      per_page:     options[:limit_value].to_i, 
      param_name:   Kaminari.config.param_name, remote: false)
    paginator.to_s
  end
end
