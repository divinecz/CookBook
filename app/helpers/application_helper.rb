# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def pluralize3(count, forms, scopes=[1, 2..4])
    case count
    when scopes[0]
      forms[0]
    when scopes[1]
      forms[1]
    else
      forms[2]
    end
  end
  
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
