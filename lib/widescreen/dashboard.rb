require 'sinatra/base'

module Widescreen
  class Dashboard < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/dashboard/views"
    set :public_folder, "#{dir}/dashboard/public"
    set :static, true
    set :method_override, true

    helpers do
      def url(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end

    get '/' do
      @metrics = Widescreen::Metric.all
      erb :metrics
    end

    get '/rename' do
      Widescreen::Metric.all.each do |metric|
        Widescreen.redis.keys("#{metric.name}|*").each do |key|
          Widescreen.redis.rename(key, key.gsub("|", ':'))
        end
      end
      redirect '/'
    end

    get '/metrics/*' do |name_and_filter|
      @metric = Widescreen::Metric.find(name_and_filter)
      erb :metric
    end

  end
end