# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (http://www.iana.org/time-zones).

module TZInfo
  module Data
    module Definitions
      module Africa
        module Bissau
          include TimezoneDefinition
          
          timezone 'Africa/Bissau' do |tz|
            tz.offset :o0, -3740, 0, :LMT
            tz.offset :o1, -3600, 0, :WAT
            tz.offset :o2, 0, 0, :GMT
            
            tz.transition 1911, 5, :o1, -1849388260, 10450868587, 4320
            tz.transition 1975, 1, :o2, 157770000
          end
        end
      end
    end
  end
end
