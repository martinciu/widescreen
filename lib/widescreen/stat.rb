module Widescreen
  class Stat
    attr_accessor :metric, :time, :value

    def initialize(metric, time, value = 1)
      @metric = metric.is_a?(Widescreen::Metric) ? metric : Widescreen::Metric.find(metric)
      @time   = compute_time(time)
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
      new(metric_name, time, value)
    end

    protected
      def key
        [metric.name, time].join(Widescreen::SEPARATOR)
      end
      
      def compute_time(time)
        time.is_a?(String) ? time : metric.time_key(time)
      end

  end
end
