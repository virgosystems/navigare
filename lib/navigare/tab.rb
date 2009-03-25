module Navigare
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
      ctrl = @options[:no_controller_check] || view.controller.controller_path == @controller.gsub(/^\/*/, '')
      ctrl && proc_or_true?(:active?, view)
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
end
