local on = false
function osc_toggle(mode)
   if on then
      mp.command ("script-message osc-visibility auto")
   else
      mp.command ("script-message osc-visibility always")
   end
   on = not on
end
mp.register_script_message("osc-toggle", osc_toggle)
