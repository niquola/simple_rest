require File.dirname(__FILE__) + '/test_helper.rb'

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
end

class MyController < ActionController::Base
  rescue_exceptions_restfully

  class MyException< Exception
  end

  rescue_from MyException do |exception|
    simple_rest({:message=>exception.to_s},{:status=>500})
  end

  def echo
    simple_rest params
  end

  def index
    result = {:field=>'value'}
    simple_rest result
  end

  def action_with_error
    raise MyException.new("Some error")
  end

  def action_with_uncatched_error
    raise Exception.new("Some error")
  end

end

class MyControllerTest < ActionController::TestCase
  def test_methods_mixed
    assert(MyController.new.respond_to?(:simple_rest))
  end

  def test_js_format
    get :index, :format => 'js'
    resp = @response.body
    assert(resp)
    resp_obj = nil
    assert_nothing_raised(Exception) {
      resp_obj = ActiveSupport::JSON.decode(resp)
    }
    assert_not_nil(resp_obj)
    assert_equal('value', resp_obj['field'])
  end

  def parse_json_responce
    resp = @response.body
    assert(resp)
    resp_obj = nil
    assert_nothing_raised(Exception) {
      resp_obj = ActiveSupport::JSON.decode(resp)
    }
    assert_not_nil(resp_obj)
    resp_obj
  end

  def test_jsonp_format
    get :index, :format => 'jsonp'
    resp_obj = parse_json_responce
    assert_not_nil(resp_obj['status'])
    assert_equal(200,resp_obj['status'])
    assert_equal('value',resp_obj['data']['field'])
  end

  def test_xml_format
    get :index, :format => 'xml'
    resp_obj = nil
    assert_nothing_raised(Exception) {
      resp_obj = html_document
    }
    assert_not_nil(resp_obj)
    #FIXME: add more asserts
  end

  def test_jsonp_exception
    get :action_with_error, :format => 'jsonp'
    resp_obj = parse_json_responce
    assert_not_nil(resp_obj['data']['message'])
    assert_equal(500,resp_obj['status'])
  end

  def test_rescue_exceptions_restfully
    get :action_with_uncatched_error, :format => 'jsonp'
    resp = @response.body
    resp_obj = parse_json_responce
    assert_not_nil(resp_obj['data']['message'])
    assert_equal(500,resp_obj['status'])
    assert_response(:ok)

    get :action_with_uncatched_error, :format => 'js'
    assert_response(500)

  end

  def test_json_request_support
    get :echo, :format => 'jsonp',:_json=>'{suboject:{field:[1,2,3]}}'
    resp_obj = nil
    resp_obj = parse_json_responce
    assert_not_nil(resp_obj['data'])
    assert_equal(2, resp_obj['data']['suboject']['field'][1])
  end
end
