module Widescreen
  module Interval
    class Minute
      include Interval
      
      def key(time)
        time.strftime('%Y-%m-%dT%H:%M')
      end
    end
  end
end