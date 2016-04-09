# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FieldsHelper
  def c_show_when_exist(f, name, edit = false, &block)
    data = ""
    if edit
      data << capture(&block)
    else
      name = name.kind_of?(Array) ? name : [name]
      should_display = name.any?{|ele|
        f.object.send(ele).present?
      }
      if should_display
        data << capture(&block)
      end
    end
    data.html_safe
  end

  def c_show_when_not_exist(f, name, edit = false, &block)
    data = ""
    if edit
      data << capture(&block)
    else
      name = name.kind_of?(Array) ? name : [name]
      should_not_display = name.any?{|ele|
        f.object.send(ele).present?
      }
      unless should_not_display
        data << capture(&block)
      end
    end
    data.html_safe
  end

  def c_textfield(f, name, edit = false, options ={}, &block)
    if edit
      f.text_field name, options
    else
      # if have value parameter
      f.object[name]
    end
  end

  def c_selectfield(f, name, allvalues , p3 , p4 , edit, &block)
    if edit
      f.select name, allvalues , p3 , p4
    else
      val = f.object.send(name)
      res = allvalues.find{|ele| val == ele.last.to_s }
      res.first
    end
  end

  def c_text_area(f, name, edit = false, options ={},&block)
    value = f.object[name]
    data = ""
    if edit
      f.text_area name, options
    else
      data << content_tag("p", value)
      data
    end
  end

  def c_autocomplete_field(f, name, edit=false, options = {}, &block)
    path = options[:path]
    if edit
      f.autocomplete_field :company, path
    else
      f.object[name]
    end
  end

end

