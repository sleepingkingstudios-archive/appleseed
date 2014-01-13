module ApplicationHelper
  def render_flash message
    rxp   = /\A%{icon:(?<icon>[A-Za-z][A-Za-z\-]*)}/
    match = rxp.match message

    if match.blank?
      message
    else
      icon = content_tag(:i, nil, :class => "fi-#{match['icon']}")
      icon + "#{match.post_match}"
    end # unless
  end # method render_flash
end # helper
