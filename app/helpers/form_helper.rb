module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    def button_success(type, *args, &block)
      options = args.extract_options!.dup
      options[:class] = ["btn", "btn-success", options[:class]].compact
      args << options
      self.button(type, *args, &block)
    end

  end
end

module ActionView
 module Helpers
   class FormBuilder
    def submit_success(value=nil, options={})
        options = options.merge({:class => "btn btn-success"})
        self.submit(value, options)
    end
   end
 end
end

module FormHelper
  # Dummy helper for simple form overrides
end