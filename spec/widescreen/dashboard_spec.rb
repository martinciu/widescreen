require 'spec_helper'

describe Widescreen::Dashboard do
  include Rack::Test::Methods

  def app
    @app ||= Widescreen::Dashboard
  end

  before(:each) do
    Widescreen.redis.flushall
    Widescreen.redis.set(['foo/bar', '2011-10-25T03:52:32+02:00'].join(Widescreen::SEPARATOR), 10)
    Widescreen.redis.set(['foo/bar', '2011-10-25T03:52:34+02:00'].join(Widescreen::SEPARATOR), 5)
    Widescreen.redis.set(['foo/bar', '2011-10-26T03:52:32+02:00'].join(Widescreen::SEPARATOR), 10)
    Widescreen::Stat.add('foo/bar', 10)
  end

  it "should respond to /" do
    get '/'
    last_response.ok?.must_equal true
  end

  it "should respond to /metrics/foo" do
    get '/metrics/foo/bar'
    last_response.ok?.must_equal true
  end

  it "should respond to /metrics/foo:2011-10-25" do
    get '/metrics/foo/bar:2011-10-25'
    last_response.ok?.must_equal true
  end

end