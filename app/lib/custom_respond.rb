module CustomRespond
  DEFAULT_RESPOND = {
      :new => {
          :html => "show",
          :js => "js/new"
      },
      :create => {
          :html => "show",
          :js => "js/create"
      },
      :edit => {
          :html => "show",
          :js => "js/edit"
      },
      :update => {
          :js => "js/update"
      },

  }

  class CustomFormat
    def initialize
      @bk = {}
    end

    def html(&block)
      @bk[:html] = block if block_given?
    end

    def js(&block)
      @bk[:js] = block if block_given?
    end

    def execute(format)
      if @bk[format]
        @bk[:html].call()
      end
    end
  end

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
    end

  end

  def respond_new_custom(model, &block)
    respond_default(model, :new, &block)
  end

  def respond_create_custom(model, &block)
    respond_default(model, :create, &block)
  end

  def respond_edit_custom (model, &block)
    respond_default(model, :edit, &block)
    end

  def respond_update_custom (model, &block)
    respond_default(model, :update, &block)
  end
end

