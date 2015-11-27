module ApplicationHelper
  def icon_link_to(icon, path, options = {})
    title = options.delete(:title)
    link_to path, options do
      content_tag(:i, " "+title, class: "fa fa-#{icon} links")
    end
  end

  def edit_link(path, options={})
    options[:title] = t(:edit)
    icon_link_to('pencil-square-o', path, options)
  end

  def delete_link(path, options={})
    options[:title] = t(:delete)
    icon_link_to('trash-o', path, options)
  end
end
