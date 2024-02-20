# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (https://www.iana.org/time-zones).

module TZInfo
  module Amagi
    module Defamagi
      module Amagi
        include TimezoneDefinition
        switch_timezone = ENV["AMAGI_DST_SWITCH_TO"]
        dst_switch_time = ENV["AMAGI_DST_SWITCH_TIME"] ? ENV["AMAGI_DST_SWITCH_TIME"] : "2024-03-08T01:00:00"
        parsed_date_time = DateTime.strptime(dst_switch_time, "%Y-%m-%dT%H:%M:%S") if dst_switch_time
        d  = dst_switch_time ? parsed_date_time.to_date : Date.current
        DEFAULT_SWITCH_OVER_EPOCH = "08:30:00"
        switch_at_time = dst_switch_time ? parsed_date_time.strftime("%H:%M:%S") : DEFAULT_SWITCH_OVER_EPOCH
        switch_over_epoch = Time.find_zone("UTC").parse(d.strftime("%Y-%m-%d") + " " + switch_at_time ).to_i
        timezone 'Amagi' do |tz|
          tz.offset :o100, 19800, 0, :AST
          tz.offset :o101, 23400, 0, :ADST
          if (switch_timezone).to_s == "AST"
            tz.transition d.year, d.month, :o100, switch_over_epoch
          elsif (switch_timezone).to_s == "ADST"
            tz.transition d.year, d.month, :o101, switch_over_epoch
          end
        end
      end
    end
  end
end
