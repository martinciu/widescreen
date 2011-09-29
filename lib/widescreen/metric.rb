module Widescreen
  class Metric
    DEFAULT_INTERVAL = "minute"
    attr_accessor :name, :interval
    
    INTERVALS = %w(day hour minute second)
    
    def initialize(name, interval = nil)
      @interval = interval || DEFAULT_INTERVAL
      @name = name
    end
    
    def new_record?
      !Widescreen.redis.sismember(:metrics, name)
    end

    def save
      return false unless valid?
      Widescreen.redis.sadd(:metrics, name) if new_record?
      Widescreen.redis.set([:metrics, name].join(Widescreen::SEPARATOR), interval)
      true
    end
    
    def valid?
      !name.empty? && INTERVALS.include?(interval)
    end
    
    def push(value)
      Stat.add(name, value)
    end
    
    def stats
      Widescreen.redis.keys("#{name}#{Widescreen::SEPARATOR}*").map { |s| Widescreen::Stat.find(s) }
    end
    
    def time_key(time)
      time.strftime('%Y-%m-%dT%H')
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

  end
end