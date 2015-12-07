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

  def cancel_link(path, options={})
    options[:title] = t(:cancel)
    icon_link_to('times', path, options)
  end

  def inline_edit_link(status_edit, options={})
    if status_edit
      options[:title] = t(:edit)
      icon = 'pencil-square-o'
    else
      options[:title] = t(:cancel)
      icon = "delete"
    end
    icon_link_to(icon, '#', options)
  end

  def delete_link(path, options={})
    options[:title] = t(:delete)
    icon_link_to('trash-o', path, options)
  end
end
