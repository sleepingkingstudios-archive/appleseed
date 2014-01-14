module ApplicationHelper
  def render_with_icon message
    rxp   = /\A%{icon:(?<icon>[A-Za-z][A-Za-z\-]*)}/
    match = rxp.match message

    if match.blank?
      message
    else
      icon = content_tag(:i, nil, :class => "fi-#{match['icon']}")
      icon + "#{match.post_match}"
    end # unless
  end # method render_with_icon

  def render_without_icon message
    rxp = /\A%{icon:(?<icon>[A-Za-z][A-Za-z\-]*)}/

    message.gsub(rxp, '')
  end # method render_without_icon
end # helper
