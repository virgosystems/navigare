module Navigare
  module Helpers
    def navigare(nav, options={})
      options = Navigare.render_options(options)
      nav = nav.is_a?(Navigare::Navigation) ? nav : Navigare.navigation(nav)
      tabs_sep = navigare_tab_separator(options)
      tabs_html = nav.tabs.map {|tab| navigare_tab(tab, options)}.compact.join(tabs_sep)
      content_tag(options[:nav_tag], tabs_html, :class => options[:nav_tag_class])
    end

    def navigare_before_tab(tab); end
    def navigare_after_tab(tab); end

    def navigare_tab(tab, options={})
      options = Navigare.render_options(options)
      return nil unless tab.available?(self)
      links = if tab.active?(self) and not tab.links.empty?
        links_sep = navigare_link_separator(options)
        links_html = tab.links.map {|link| navigare_link(link, options)}.join(links_sep)
        links_html = content_tag(options[:menu_tag], links_html, :class => options[:menu_class])
        if options[:extra_content]
          before = navigare_before_tab(tab)
          after = navigare_after_tab(tab)
          links = content_tag(
            options[:menu_tag_with_extra_content],
            "#{before}#{links_html}#{after}",
            :class => options[:menu_class_with_extra_content]
          )
        else
          links_html
        end
      end
        
      tab_title = if tab.default_link
        navigare_link(tab.default_link, :title => tab.title(self), :plain => true)
      else
        tab.title(self)
      end
      tab_class = options[:tab_class]
      tab_class += " #{options[:tab_active_class]}" if tab.active?(self)
      content_tag(options[:tab_tag], "#{tab_title}\n#{links}", :class => tab_class)
    end

    def navigare_tab_separator(options={})
      options = Navigare.render_options(options)
      if options[:tab_separator]
        content_tag(options[:tab_separator_tag], options[:tab_separator], :class => options[:tab_separator_class])
      else
        "\n"
      end
    end

    def navigare_link(link, options={})
      options = Navigare.render_options(options)
      text = if title = options.delete(:title)
        title
      elsif link.name.is_a?(Symbol)
        I18n.translate(link.name, :scope => [:navigation, link.tab.nav.name, link.tab.name])
      else
        name
      end
      path = url_for(link.url_for_args(self))
      link = link_to(text, path, link.html_options(self))
      if options[:plain]
        link
      else
        content_tag(options[:link_tag], link, :class => options[:link_class])
      end
    end

    def navigare_link_separator(options={})
      options = Navigare.render_options(options)
      if options[:link_separator]
        content_tag(options[:link_separator_tag], options[:link_separator], :class => options[:link_separator_class])
      else
        "\n"
      end
    end
  end
end
