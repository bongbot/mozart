# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module UsersHelper
  def language_for(user)
    if user.preference[:locale]
      locale, language = languages.detect { |locale, _language| locale == user.preference[:locale] }
    end
    language || "English"
  end

  def sort_by_language
    languages.sort.map do |locale, language|
      %[{ name: "#{language}", on_select: function() { #{redraw(:locale, [locale, language], url_for(action: :redraw, id: current_user))} } }]
    end
  end

  def all_users
    User.by_name
  end

  def user_select(asset, users, myself, editable=false)
    if editable
      user_options = user_options_for_select(users, myself)
      select(asset, :assigned_to, user_options,
             { include_blank: t(:unassigned) },
             style:         "width:160px",
             class: 'select2 ')
    else
      user_options = user_options_for_select(users, myself)
      model = instance_variable_get("@#{asset.to_s}")
      res = user_options.find{|user|
        user.last == model.send(:assigned_to)
      }
      data = res ? res.first : (t :unassigned)
      data
    end
  end

  def user_options_for_select(users, myself)
    (users - [myself]).map { |u| [u.full_name, u.id] }.prepend([t(:myself), myself.id])
  end

  def full_name(object)
    res = [:first_name, :last_name].inject([]) do |memo, ele|
      val = object.send(ele)
      memo << val if val.present?
    end
    res.join(" ")
  end
end
