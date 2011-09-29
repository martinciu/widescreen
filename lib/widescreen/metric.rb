module Widescreen
  class Metric
    DEFAULT_INTERVAL = "hour"
    attr_accessor :name, :interval
    
    INTERVALS = %w(day hour minute second)
    
    def initialize(name, interval_name = nil)
      @interval = get_interval(interval_name)
      @name     = name
    end
    
    def new_record?
      !Widescreen.redis.sismember(:metrics, name)
    end

    def save
      return false unless valid?
      Widescreen.redis.sadd(:metrics, name) if new_record?
      Widescreen.redis.set([:metrics, name].join(Widescreen::SEPARATOR), interval.name)
      true
    end
    
    def valid?
      !name.empty? && !interval.nil? && INTERVALS.include?(interval.name)
    end
    
    def push(value)
      Widescreen::Stat.add(self, value)
    end
    
    def stats
      Widescreen.redis.keys("#{name}#{Widescreen::SEPARATOR}*").map { |s| Widescreen::Stat.find(s) }
    end
    
    def time_key(time)
      interval.key(time)
    end
      
    def self.find(name)
      new(name, Widescreen.redis.get([:metrics, name].join(Widescreen::SEPARATOR))) if Widescreen.redis.sismember(:metrics, name)
    end
    
    def self.all
      Widescreen.redis.smembers(:metrics).map {|m| find(m)}
    end

    def self.create(name, interval = nil)
      metric = new(name, interval)
      metric.save
      metric
    end
    
    protected
      def get_interval(interval_name)
        interval_name    = interval_name || DEFAULT_INTERVAL
        interval_name[0] = interval_name[0].upcase
        Object.module_eval("Widescreen::Interval::#{interval_name}", __FILE__, __LINE__).new
      rescue
        nil
      end
  end
end