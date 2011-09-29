module Widescreen
  class Stat
    attr_accessor :metric_name, :time, :value
    
    def initialize(metric_name, time, value = 1)
      @metric_name = metric_name
      @time        = time
      @value       = value
    end
    
    def self.add(metric_name, value = 1)
      Widescreen.redis.incrby([metric_name, Time.now.strftime('%Y-%m-%dT%H')].join(Widescreen::SEPARATOR), value)
    end
    
    def self.find(key)
      metric_name, time = key.split(Widescreen::SEPARATOR, 2)
      value = Widescreen.redis.get(key)
      value ? new(metric_name, time, value) : nil
    end
    
  end
end