module CustomRespond
  DEFAULT_ALLOWED = [:index, :new, :edit, :create, :update, :redraw, :filter]

  DEFAULT_RESPOND = {
      :index => {
          :html => "index",
          :js => "js/index"
      },
      :new => {
          :html => "show",
          :js => "js/new"
      },
      :edit => {
          :html => "show",
          :js => "js/edit"
      },
      :create => {
          :html => "show",
          :js => "js/create"
      },
      :update => {
          :js => "js/update"
      },
      :redraw => {
          :html => "index",
          :js => "js/index"
      },
      :filter => {
          :html => "index",
          :js => "js/index"
      },

  }

  class CustomFormat
    def initialize
      @bk = {}
    end

    ["html", "js", "xls", "csv"].each do |action|
      define_method("#{action}") do
        @bk[action.to_sym] = block if block_given?
      end
    end

    def execute(format)
      if @bk[format]
        @bk[:html].call()
      end
    end
  end

  # Helper to ease responding
  # @param model Object
  # @param mode Show, Edit, New, ...
  def respond_default(model, mode)
    res = DEFAULT_RESPOND[mode]
    custom_format = CustomFormat.new
    yield(custom_format) if block_given?
    respond_with(model) do |format|
      format.html {
        custom_format.execute(:html)
        render res[:html]
      }

      format.js {
        custom_format.execute(:js)
        render :action => res[:js]
      }

      format.xls {
        custom_format.execute(:xls)
      }

      format.csv {
        custom_format.execute(:csv)
      }
    end

  end

  # def respond_new_custom(model, &block)
  #   respond_default(model, :new, &block)
  # end
  #
  # def respond_create_custom(model, &block)
  #   respond_default(model, :create, &block)
  # end
  #
  # def respond_edit_custom (model, &block)
  #   @edit = true if request.format.html?
  #   respond_default(model, :edit, &block)
  # end

  # def respond_update_custom (model, &block)
  #   respond_default(model, :update, &block)
  # end

  def respond_custom (model, &block)
    # return if some how @return is set to true
    if @return
      return
    end

    action = params[:action].to_sym
    if DEFAULT_ALLOWED.include?(action)
      @edit = true if (request.format.html? and action == :edit)
      respond_default(model, action, &block)
    else
      respond_with(model) do |format|
        yield(format) if block_given?
        format.js {
          render :action => "js/" + params[:action]
        }
      end
    end
  end

  def respond_special_custom(action)
    render :action => "js/" + action.to_s
  end
end

