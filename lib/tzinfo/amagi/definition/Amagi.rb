module TZInfo
  module Amagi
    module Definition
      module Amagi

        DEFAULT_SWITCH_OVER_EPOCH = "08:30:00"

        include TimezoneDefinition
        switch_timezone = ENV["AMAGI_DST_SWITCH_TO"]
        dst_switch_time = ENV["AMAGI_DST_SWITCH_TIME"]
        parsed_date_time = DateTime.strptime(dst_switch_time, "%Y-%m-%dT%H:%M:%S") if dst_switch_time
        d  = dst_switch_time ? parsed_date_time.to_date : Date.current
        switch_at_time = dst_switch_time ? parsed_date_time.strftime("%H:%M:%S") : DEFAULT_SWITCH_OVER_EPOCH
        switch_over_epoch = Time.find_zone("UTC").parse(d.strftime("%Y-%m-%d") + " " + switch_at_time ).to_i
        if switch_timezone == "AST"
          timezone 'Amagi' do |tz|
            tz.offset :o0, 23400, 0, :ADST
            tz.offset :o1, 19800, 0, :AST

            tz.transition d.year, d.month, :o1, switch_over_epoch

          end
        elsif switch_timezone == "ADST"
          timezone 'Amagi' do |tz|
            tz.offset :o0, 19800, 0, :AST
            tz.offset :o1, 23400, 0, :ADST

            tz.transition d.year, d.month, :o1, switch_over_epoch

          end
        end

      end
    end
  end
end
