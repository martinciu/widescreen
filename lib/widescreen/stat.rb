module Widescreen
  class Stat
    attr_accessor :metric, :time, :value

    def initialize(metric, time, value = 1)
      @metric = Widescreen::Metric.find_or_create(metric)
      @time   = time
      @value  = value
    end

    def save
      Widescreen.redis.incrby(key, value)
    end

    def self.add(metric, value = 1)
      new(metric, Time.now, value).save
    end
    
    def self.find(key)
      value = Widescreen.redis.get(key)
      return if value.nil?
      metric_name, time = key.split(Widescreen::SEPARATOR, 2)
      new(metric_name, Time.parse(time), value)
    end

    protected
      def key
        [metric.name, time_string].join(Widescreen::SEPARATOR)
      end

      def time_string
        time.iso8601
      rescue NoMethodError
        time
      end
      
  end
end
