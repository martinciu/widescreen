require 'spec_helper'

describe Widescreen::Metric do

  before(:each) do
    Widescreen.redis.flushall
  end

  describe "instance methods" do
    it "have name" do
      Widescreen::Metric.new("foo").name.must_equal "foo"
    end

    it "can be saved" do
      metric = Widescreen::Metric.new("foo")
      metric.save
      Widescreen.redis.sismember(:metrics, "foo").must_equal true
    end

    it "knows when it is a new record" do
      metric = Widescreen::Metric.new("foo")
      metric.new_record?.must_equal true
    end
    
    it "knows whem it is existed record" do
      metric = Widescreen::Metric.new("foo")
      metric.save
      metric.new_record?.must_equal false
    end
  end

  describe "class methods" do
    describe "create" do
      it "saves object" do
        Widescreen::Metric.create("foo")
        Widescreen.redis.sismember(:metrics, "foo").must_equal true
      end

      it "returns Metric" do
        Widescreen::Metric.create("foo").must_be_instance_of Widescreen::Metric
      end
    end

    describe "all" do
      before(:each) do
        Widescreen::Metric.create("foo")
        Widescreen::Metric.create("bar")
        Widescreen::Metric.create("baz")
      end

      it "returns array" do
        Widescreen::Metric.all.must_be_instance_of Array
      end

      it "returns array of Metrics" do
        Widescreen::Metric.all.each do |metric|
          metric.must_be_instance_of Widescreen::Metric
        end
      end

      it "returns all metrics" do
        Widescreen::Metric.all.size.must_equal 3
      end
    end
    
    describe "stats" do
      before(:each) do
        @metric = Widescreen::Metric.create("foo")
        now = Time.now
        [1, 2, 5].each do |n|
          Timecop.freeze(now - n*3600) do
            Widescreen::Stat.add("foo")
          end
        end
        Timecop.freeze(now)
      end
      
      after(:each) do
        Timecop.return
      end
      
      it "returns 3 stats" do
        @metric.stats.size.must_equal 3
      end
      
      it "returns array" do
        @metric.stats.must_be_instance_of Array
      end
      
      it "returns stats" do
        @metric.stats.each do |m|
          m.must_be_instance_of Widescreen::Stat
        end
      end
      
    end

  end
end
