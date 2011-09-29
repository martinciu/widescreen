module Widescreen
  module Interval
    class Hour
      include Interval
      
      def key(time)
        time.strftime('%Y-%m-%dT%H')
      end
    end
  end
end