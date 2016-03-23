# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FieldsHelper
  def c_show_when_exist(f, name, &block)
    value = f.object[name]
    data = ""
    if(value.present?)
      data << capture(&block)
    end
    data.html_safe
  end

  def c_textfield(f, name, &block)
    f.object[name]
  end

  def c_text_area(f, name, &block)
    value = f.object[name]
    data = ""
    data << content_tag("p", value)
    data
  end

  def c_autocomplete_field(f, name, &block)
    f.object[name]
  end
end

