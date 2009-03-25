module Navigare
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
end
