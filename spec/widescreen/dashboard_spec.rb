require 'spec_helper'

describe Widescreen::Dashboard do
  include Rack::Test::Methods

  def app
    @app ||= Widescreen::Dashboard
  end

  before(:each) do
    Widescreen.redis.flushall
    Widescreen::Stat.add('foo', 10)
  end

  it "should respond to /" do
    get '/'
    last_response.ok?.must_equal true
  end

  it "should respond to /metrics/foo" do
    get '/metrics/foo'
    last_response.ok?.must_equal true
  end

end