require 'spec_helper'

describe Widescreen::Stat do
  before(:each) do
    Widescreen.redis.flushall
  end
  
  describe "instance methods" do
    describe "initialize" do
      before(:each) do
        Timecop.freeze
        @metric = Widescreen::Metric.create("foo")
        @time = Time.now.iso8601
        @stat = Widescreen::Stat.new("foo", @time, 5)
      end
      
      after(:each) do
        Timecop.return
      end

      it "has metric" do
        @stat.metric.must_be_instance_of Widescreen::Metric
      end
      
      it "has time" do
        @stat.time.must_equal @time
      end
      
      it "has value" do
        @stat.value.must_equal 5
      end
    end
    
    describe "find" do
      before(:each) do
        @key = ["foo", Time.now.strftime('%Y-%m-%dT%H')].join(Widescreen::SEPARATOR)
        Widescreen.redis.set(@key, 10)
      end
      
      it "returns instance of Stat if it exist" do
        Widescreen::Stat.find(@key).must_be_instance_of Widescreen::Stat
      end
      
      it "returns nil if not found" do
        Widescreen::Stat.find("#{@key}1").must_be_nil
      end
      
    end
  end

  describe "class methods" do
    describe "add" do
      before(:each) do
        Timecop.freeze
        @time = Time.now.iso8601
        @metric_name = "foo"
        Widescreen::Metric.create(@metric_name)
        @key = [@metric_name, @time].join(Widescreen::SEPARATOR)
      end

      after(:each) do
        Timecop.return
      end

      describe "when no entry for a given time" do
        it "creates entry with default value" do
          Widescreen::Stat.add(@metric_name)
          Widescreen.redis.get(@key).must_equal "1"
        end

        it "creates entry with value" do
          Widescreen::Stat.add(@metric_name, 5)
          Widescreen.redis.get(@key).must_equal "5"
        end
      end

      describe "when there is an entry for a given time" do
        before(:each) do
          Widescreen::Stat.add(@metric_name, 5)
        end

        it "updates entry with default value" do
          Widescreen::Stat.add(@metric_name)
          Widescreen.redis.get(@key).must_equal "6"
        end

        it "updates entry with value" do
          Widescreen::Stat.add(@metric_name, 5)
          Widescreen.redis.get(@key).must_equal "10"
        end

      end

    end
  end

end
