module Widescreen
  class Metric
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
    
    def new_record?
      !Widescreen.redis.sismember(:metrics, name)
    end

    def save
      if new_record?
        Widescreen.redis.sadd(:metrics, name)
      end
    end
    
    def push(value)
      Stat.add(name, value)
    end
    
    def stats
      Widescreen.redis.keys("#{name}|*").map { |s| Widescreen::Stat.find(s) }
    end
    
    def self.find(name)
      new(name)
    end
    
    def self.all
      Widescreen.redis.smembers(:metrics).map {|m| find(m)}
    end

    def self.create(name)
      metric = new(name)
      metric.save
      metric
    end

  end
end