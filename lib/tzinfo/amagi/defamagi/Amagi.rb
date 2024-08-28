# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (https://www.iana.org/time-zones).

module TZInfo
  module Amagi
    module Defamagi
      module Amagi
        include TimezoneDefinition
        switch_timezone = ENV["AMAGI_DST_SWITCH_TO"]
        dst_switch_time = ENV["AMAGI_DST_SWITCH_TIME"]
        parsed_date_time = dst_switch_time ? DateTime.strptime(dst_switch_time, "%Y-%m-%dT%H:%M:%S") : Date.current
        d  = dst_switch_time ? parsed_date_time.to_date : Date.current
        DEFAULT_SWITCH_OVER_EPOCH = "08:30:00"
        switch_at_time = dst_switch_time ? parsed_date_time.strftime("%H:%M:%S") : DEFAULT_SWITCH_OVER_EPOCH
        switch_over_epoch = Time.find_zone("UTC").parse(d.strftime("%Y-%m-%d") + " " + switch_at_time ).to_i
        timezone 'Amagi' do |tz|
          tz.offset :o100, 23400, 0, :ADST # 6:30
          tz.offset :o101, 19800, 0, :AST  # 5:30
          if (switch_timezone).to_s == "AST"
            tz.transition 2000, 4, :o100, 954658800
            tz.transition d.year, d.month, :o101, switch_over_epoch
          elsif (switch_timezone).to_s == "ADST"
            tz.transition 2000, 4, :o101, 954658800
            tz.transition d.year, d.month, :o100, switch_over_epoch
          end
        end
      end
    end
  end
end
