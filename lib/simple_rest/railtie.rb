module SimpleRest
  class Railtie < Rails::Railtie
    initializer 'simple_rest.enable' do
      SimpleRest.enable
    end
  end
end