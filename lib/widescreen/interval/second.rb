module Widescreen
  module Interval
    class Second
      include Interval
      
      def key(time)
        time.strftime('%Y-%m-%dT%H:%M:%S')
      end
    end
  end
end