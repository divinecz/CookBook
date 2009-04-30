# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def onload_focus
    " onload=\'document.forms[#{ @focus_f || 0 }].elements[#{ @focus_e || 1 }].select()\'" if @focus_f || @focus_e
  end
end
