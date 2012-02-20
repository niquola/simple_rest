module SimpleRest
  module ActionControllerResponderMethods
    extend ActiveSupport::Concern

    included do
      alias_method :default_to_html, :to_html

      def to_html
        begin
          simple_to_html
        rescue ActionView::MissingTemplate
          default_to_html
        end
      end

      def to_js
        simple_to_js
      end
    end

    def simple_to_js
      status = options[:status] || :ok
      render :json => resource.to_json(options[:serialize_opts] || {}), :status => status
    end

    def to_yaml
      status = options[:status] || :ok
      render :partial => 'shared/inspect', :content_type => 'text/html', :locals => {:data => resource}, :status => status
    end

    def to_pdf
      render (options[:pdf_opts] || {}).merge(:layout => false)
    end

    def to_xml
      status = options[:status] || :ok
      render :xml => resource.to_xml(options[:serialize_opts] || {}), :status => status
    end

    def to_jsonp
      text = build_jsonp_message(resource, options)
      render ({:content_type => :js, :text => text}.merge(options.merge(:status => :ok)))
    end

    def simple_to_html
      render options
    end

    def build_jsonp_message(data, options)
      message = {:status => options[:status] || 200, :data => data}
      json = message.to_json(options)
      callback, variable = controller.params[:callback], controller.params[:variable]
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
end