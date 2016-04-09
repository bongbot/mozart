module PermissionsHelper
  def permissedid_to_name(user_ids, users)
    data = ""
    if user_ids.blank?
      data << "N/A"
    else
      user_hash = {}
      users.map{ |user|
        user_hash[user.last] = user.first
      }

      user_ids.each{ |user_id|
        data << %Q(<a class="link_tag" href="#{user_id}">#{user_hash[user_id]}</a>  )
      }
    end

    data.html_safe
  end

end
