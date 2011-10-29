module Widescreen
  class Metric
    attr_accessor :name, :filter
    
    def initialize(name_and_filter)
      @name, @filter = name_and_filter.split(Widescreen::SEPARATOR, 2)
      @filter = "#{@filter}*"
    end
    
    def new_record?
      !Widescreen.redis.sismember(:metrics, name)
    end

    def save
      return false unless valid?
      Widescreen.redis.sadd(:metrics, name) if new_record?
      true
    end
    
    def valid?
      !name.nil? && !name.empty?
    end
    
    def push(value)
      Widescreen::Stat.add(self, value)
    end
    
    def stats
      Widescreen.redis.keys([name, filter].join(Widescreen::SEPARATOR)).map { |s| Widescreen::Stat.find(s) }
    end
    
    def self.find(name)
      new(name)
    end

    def to_s
      name
    end

    def self.find_or_create(metric)
      if Widescreen.redis.sismember(:metrics, metric)
        find(metric)
      else
        create(metric)
      end
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