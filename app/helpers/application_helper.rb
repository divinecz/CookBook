# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def focus(element, form = 0)
    content_for :body do
      " onload='document.forms[#{form}].elements[#{element}].select();'"
    end
  end
  
  def title(title)
    content_for :title do
      title = [title, 'O vaření.cz'].join(' – ')
    end
    title
  end
end
