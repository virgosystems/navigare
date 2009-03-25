module Navigare
  class Link
    attr_reader :tab, :name

    def initialize(tab, name, params={}, options={})
      @tab, @name, @options = tab, name, options
      @html_options = params.delete(:html) || {}
      @url_for_args = {
        :controller => tab.controller,
        :action => name.to_s
      }.merge(params)
    end

    def url_for_args(view)
      resolve_procs(@url_for_args, view)
    end
    
    def html_options(view)
      resolve_procs(@html_options, view)
    end
    
    private
      def resolve_procs(hash, view)
        args = hash.dup
        args.each do |key, value|
          args[key] = view.instance_eval(&value) if value.is_a?(Proc)
        end
        args
      end
  end
end
