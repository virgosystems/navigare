%w{ navigation tab link helpers }.each {|lib| require(File.join("navigare", lib))}

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
end
