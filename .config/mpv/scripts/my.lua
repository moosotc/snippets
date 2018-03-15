local on = false
function osc_toggle (mode)
   if on then
      mp.command ("script-message osc-visibility auto")
   else
      mp.command ("script-message osc-visibility always")
   end
   on = not on
end
mp.register_script_message ("osc-toggle", osc_toggle)

-- function clear (name, value)
--    if value > 0 then
--       mp.osd_message (" ", 0.001)
--     end
-- end
-- mp.observe_property ("osd-width", "number", clear)
