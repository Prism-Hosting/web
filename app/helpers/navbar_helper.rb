module NavbarHelper
  def nav_bar_link(title, path, context)
    content_tag :li, class: "nav-item #{current_context == context ? 'active' : ''}" do
      link_to title, path, class: 'nav-link'
    end
  end
end
