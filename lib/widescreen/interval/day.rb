module Widescreen
  module Interval
    class Day
      include Interval
      
      def key(time)
        time.strftime('%Y-%m-%d')
      end
    end
  end
end