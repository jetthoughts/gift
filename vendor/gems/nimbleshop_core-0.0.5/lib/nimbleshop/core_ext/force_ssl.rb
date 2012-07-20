#
# Rails's version of force_ssl does not force ssl in development environment.
#
# In this monkey patch that constraint has been removed. Notice the '#' before &&.
# The only code added was that single '#'
#
module ActionController
  module ForceSSL
    extend ActiveSupport::Concern
    include AbstractController::Callbacks

    module ClassMethods
      def force_ssl(options = {})
        host = options.delete(:host)
        before_filter(options) do
          if !request.ssl?# && !Rails.env.development?
            redirect_options = {:protocol => 'https://', :status => :moved_permanently}
            redirect_options.merge!(:host => host) if host
            redirect_options.merge!(:params => request.query_parameters)
            redirect_to redirect_options
          end
        end
      end
    end
  end
end
