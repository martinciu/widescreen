module Widescreen
  module Interval
    def name
      self.class.name.split("::").last.downcase
    end
  end
end

require 'widescreen/interval/second'
require 'widescreen/interval/minute'
require 'widescreen/interval/hour'
require 'widescreen/interval/day'
