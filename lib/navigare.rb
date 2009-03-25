module Navigare
  DEFAULT_RENDER_OPTIONS = {
    :nav_tag => 'ul',
    :nav_class => 'nav',
    :tab_tag => 'li',
    :tab_class => 'tab',
    :tab_active_class => "active",
    :tab_separator => nil,
    :tab_separator_tag => 'span',
    :tab_separator_class => 'separator',
    :menu_tag => 'ul',
    :menu_class => 'menu',
    :extra_content => false,
    :menu_tag_with_extra_content => 'div',
    :menu_class_with_extra_content => 'submenu',
    :link_tag => 'li',
    :link_class => 'menu_link',
    :link_separator => nil,
    :link_separator_tag => 'span',
    :link_separator_class => 'separator'
  }
  def self.render_options(options={})
    DEFAULT_RENDER_OPTIONS.merge(options)
  end

  def self.build(*args, &block)
    Navigation.new(*args, &block)
  end

  def self.navigation(name)
    Navigation.navigations[name.to_sym]
  end

  class Navigation
    @@navigations = {}
    cattr_reader :navigations

    attr_reader :name, :tabs, :namespace

    def initialize(name, options={})
      @name, @options = name, options
      @namespace = @options.delete(:namespace)
      @tabs = []
      yield(self)
      @@navigations[name.to_sym] = self
    end

    def tab(name, options={}, &block)
      @tabs << Tab.new(self, name, options, &block)
    end
  end

  class Tab
    attr_reader :nav, :name, :links, :controller

    def initialize(nav, name, options={})
      @nav, @name, @options = nav, name, options
      @links = []
      @controller = (@options.delete(:controller) || name).to_s
      if not nav.namespace.blank? and @controller[0] != ?/
        @controller = "#{nav.namespace}/#{@controller}"
      end
      yield(self)
    end

    def link(name, params={})
      is_default = params.delete(:default)
      link = Link.new(self, name, params)
      @links << link
      @default_link = link if is_default
    end

    def default_link
      defined?(@default_link) ? @default_link : links.first
    end

    def title(view)
      if @options.has_key?(:title)
        @options[:title].is_a?(Proc) ? view.instance_eval(&@options[:title]) : @options[:title]
      elsif name.is_a?(Symbol)
        I18n.translate(:tab_title, :scope => [:navigation, nav.name, name])
      else
        name
      end
    end

    def available?(view)
      proc_or_true?(:available?, view)
    end

    def active?(view)
      view.controller.controller_path == @controller.gsub(/^\/*/, '') and proc_or_true?(:active?, view)
    end

    private
      def proc_or_true?(key, view)
        if @options.has_key?(key)
          @options[key].is_a?(Proc) ? view.instance_eval(&@options[key]) : @options[key]
        else
          true
        end
      end
  end

  class Link
    attr_reader :tab, :name

    def initialize(tab, name, params={}, options={})
      @tab, @name, @options = tab, name, options
      @url_for_args = {
        :controller => tab.controller,
        :action => name.to_s
      }.merge(params)
    end

    def url_for_args(view)
      @url_for_args.dup.tap do |args|
        args.each do |key, value|
          args[key] = view.instance_eval(&value) if value.is_a?(Proc)
        end
      end
    end
  end

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
      link = link_to(text, path)
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
