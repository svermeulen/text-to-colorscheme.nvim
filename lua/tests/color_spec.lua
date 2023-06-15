local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs
require("busted")

local RgbColor = require("text-to-colorscheme.internal.rgb_color")
local HsvColor = require("text-to-colorscheme.hsv_color")
local asserts = require("text-to-colorscheme.internal.asserts")
local color_util = require("text-to-colorscheme.internal.color_util")

describe("RgbColor", function()
   it("color_lerp", function()
      local hex1 = "#8effaa"
      local hex2 = "#c495d8"
      local hsv1 = color_util.hex_to_hsv(hex1)
      local hsv2 = color_util.hex_to_hsv(hex2)

      local new1 = color_util.hsv_lerp(hsv1, hsv2, 0.5)
      local new2 = color_util.hsv_lerp(hsv2, hsv1, 0.5)

      asserts.that(new1:is_approximately_equal(new2, 0.05))
   end)

   it("value_conversions", function()


      local expected_values = {
         { "#8effaa", RgbColor(0.556863, 1.0, 0.666667), HsvColor(0.372222, 0.44, 1.0) },
         { "#463268", RgbColor(0.27451, 0.196078, 0.407843), HsvColor(0.727778, 0.51, 0.4) },
         { "#c495d8", RgbColor(0.768627, 0.584314, 0.847059), HsvColor(0.783333, 0.31, 0.84) },
      }

      local epsilon = 0.1

      for _, values in ipairs(expected_values) do
         local hex = values[1]
         local rgb = values[2]
         local hsv = values[3]


         asserts.that(rgb:is_approximately_equal(color_util.hex_to_rgb(hex), epsilon))
         asserts.is_equal(color_util.rgb_to_hex(color_util.hex_to_rgb(hex)), hex)


         asserts.that(hsv:is_approximately_equal(color_util.rgb_to_hsv(rgb), epsilon))

         asserts.that(color_util.hsv_to_rgb(hsv):is_approximately_equal(rgb, epsilon))
      end
   end)

   it("is_valid_hex_color", function()
      asserts.that(color_util.is_valid_hex_color("#123456"))
      asserts.that(color_util.is_valid_hex_color("#a2b4f6"))
      asserts.that(color_util.is_valid_hex_color("#02B4F6"))
      asserts.that(not color_util.is_valid_hex_color("#0000"))
      asserts.that(not color_util.is_valid_hex_color("#00z000"))
      asserts.that(not color_util.is_valid_hex_color("000000"))
   end)

   it("converts to hex and back", function()
      local hex_value = "#ff167b"
      asserts.is_equal(hex_value, color_util.rgb_to_hex(color_util.hex_to_rgb(hex_value)))
   end)
end)
