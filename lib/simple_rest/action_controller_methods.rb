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

    def simple_rest(data, opts={})
      status= opts[:status] || :ok
      serial_opts= opts[:serialize_opts] || {}
      respond_to do |format|
        format.js { render :json => data.to_json(serial_opts),:status=>status}
        format.html { render}
        format.yaml { render :partial=> 'shared/inspect',:content_type =>'text/html',:locals => { :data => data } ,:status=>status }
        format.xml  { render :xml => data.to_xml(serial_opts),:status=>status}
        format.pdf  { render (opts[:pdf_opts] || {}).merge(:layout=>false) }
        format.jsonp { render_jsonp(data,opts) }
      end
    end

    def render_jsonp(data, options={})
      text = build_jsonp_message(data,options)
      render({:content_type => :js, :text => text}.merge(options.merge(:status=>:ok)))
    end

    def build_jsonp_message(data,options)
      message = {:status=>options[:status] || 200, :data=>data}
      json=message.to_json(options)
      callback, variable = params[:callback], params[:variable]
      response =
      begin
        if callback && variable
          "var #{variable} = #{json};\n#{callback}(#{variable});"
        elsif variable
          "var #{variable} = #{json};"
        elsif callback
          "#{callback}(#{json});"
        else
          json
        end
      end
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
