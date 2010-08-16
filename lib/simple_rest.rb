$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
module SimpleRest
  VERSION = '0.0.3'
  autoload :ActionControllerMethods, 'simple_rest/action_controller_methods'
  class << self
    def enable
      ActionController::Base.send :include, ActionControllerMethods
      enable_mime_types
    end

    def enable_mime_types
      unless defined? Mime::PDF
        Mime::Type.register("application/pdf", :pdf)
      end
      unless defined? Mime::JSONP
        Mime::Type.register("text/javascript", :jsonp)
      end
    end
  end
end

if defined? ActionController
  SimpleRest.enable if defined? ActionController
end
