require 'spec_helper'

describe Widescreen::Metric do

  before(:each) do
    Widescreen.redis.flushall
  end

  describe "instance methods" do
    describe "initialize" do
      it "set name" do
        Widescreen::Metric.new("foo").name.must_equal "foo"
      end
      it "set interval " do
        Widescreen::Metric.new("foo", "hour").interval.must_equal "hour"
      end
      it "set default interval " do
        Widescreen::Metric.new("foo").interval.must_equal Widescreen::Metric::DEFAULT_INTERVAL
      end
    end

    describe "save" do
      it "saves valid record" do
        metric = Widescreen::Metric.new("foo")
        metric.save.must_equal true
        Widescreen.redis.sismember(:metrics, "foo").must_equal true
      end
      it "doesn't save invalid record" do
        metric = Widescreen::Metric.new("")
        metric.save.must_equal false
        Widescreen.redis.sismember(:metrics, "foo").must_equal false
      end
    end

    describe "valid?" do
      it "returns true if name is not empty" do
        Widescreen::Metric.new("foo").valid?.must_equal true
      end
      it "returns false if name is empty" do
        Widescreen::Metric.new("").valid?.must_equal false
      end
      it "returns false if interval is incorrect " do
        Widescreen::Metric.new("foo", "bar").valid?.must_equal false
      end
    end

    describe "new_record?" do
      before {@metric = Widescreen::Metric.new("foo")}
      it { @metric.new_record?.must_equal true }
      
      it "knows when it is an existed record" do
        @metric.save
        @metric.new_record?.must_equal false
      end
    end

  end

  describe "class methods" do
    describe "create" do
      before { @metric = Widescreen::Metric.create("foo") }
      it { Widescreen.redis.sismember(:metrics, "foo").must_equal true }
      it { @metric.must_be_instance_of Widescreen::Metric }
    end

    describe "all" do
      before(:each) do
        Widescreen::Metric.create("foo")
        Widescreen::Metric.create("bar")
        Widescreen::Metric.create("baz")
      end

      it { Widescreen::Metric.all.must_be_instance_of Array }
      it { Widescreen::Metric.all.size.must_equal 3 }
      it "returns array of Metrics" do
        Widescreen::Metric.all.each do |metric|
          metric.must_be_instance_of Widescreen::Metric
        end
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

      it { @metric.stats.size.must_equal 3 }
      it { @metric.stats.must_be_instance_of Array}
      
      it "returns instances of Stat" do
        @metric.stats.each do |m|
          m.must_be_instance_of Widescreen::Stat
        end
      end

    end

  end
end
