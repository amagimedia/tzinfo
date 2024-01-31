module TZInfo
  module Amagi
    module Definition
      module Amagi
        include TimezoneDefinition
        d = Date.current
        d = Date.parse(ENV["AMAGI_DST_DATE"]) if ENV["AMAGI_DST_DATE"]
        switch_over_epoch = ENV["AMAGI_DST_SWITCH_TIME"] ? Time.find_zone("UTC").parse(d.strftime("%Y-%m-%d") + " " + ENV["AMAGI_DST_SWITCH_TIME"] ).to_i : Time.find_zone("UTC").parse(d.strftime("%Y-%m-%d") + " " + "08:30:00").to_i
        adst_offset = ENV["AMAGI_DST_SWITCH_OFFSET"] ? (ENV["AMAGI_DST_SWITCH_OFFSET"]).to_i : 23400
        initial_offset = ENV["AMAGI_DST_INITIAL_OFFSET"] ? (ENV["AMAGI_DST_INITIAL_OFFSET"]).to_i : 19800
        timezone 'Amagi' do |tz|
          tz.offset :o0, initial_offset, 0, :AST
          tz.offset :o1, adst_offset, 0, :ADST

          tz.transition d.year, d.month, :o1, switch_over_epoch

        end
      end
    end
  end
end
