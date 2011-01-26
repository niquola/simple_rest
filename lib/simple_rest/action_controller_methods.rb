module SimpleRest
  module ActionControllerMethods
    def self.included(base)
      base.extend(ClassMethods)
      base.before_filter :json_request_handling_filter
    end

    module ClassMethods
      def rescue_exceptions_restfully
        rescue_from Exception do |exception|
          simple_rest({:message=>exception.to_s},{:status=>500})
        end
      end
    end

    #FIXME: add decode exception handling
    def json_request_handling_filter
      if params[:_json]
        json_params = ActiveSupport::JSON.decode(params[:_json])
        params.delete(:_json)
        params.merge!(json_params)
      end
    end

    def simple_rest(data, opts = {})
      ::ActiveSupport::Deprecation.warn("simple_rest is deprecated. Please use respond_with instead")
      respond_with data, opts
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

  end
end
