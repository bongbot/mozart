# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AddressesHelper
  # Sets up new address when used in forms.
  #----------------------------------------------------------------------------
  def get_address(asset, type)
    asset.send("build_#{type}".to_sym) if asset.send(type.to_sym).nil?
    asset.send(type.to_sym)
  end

  def priority_countries
    Setting[:priority_countries]
    puts "TTT: " + Setting[:priority_countries].inspect
  end

  def address_exist?(address)
    fields = [:street1,:street2,:city,:state,:zipcode,:country]
    fields.any?{|field| address[field].present?}
  end

  def address_display(address)
    if address.present?
      res = []
      street = address.street1 + " " + address.street2
      if street.present?
        res << street
      end

      [:city, :state, :zipcode].each do |ele|
        val = address.send(ele)
        if val.present?
          res << val
        end
      end

      country = address.send(:country)
      if country.present?
        country_val = ISO3166::Country[country] ? ISO3166::Country[country] .name : ""
        res << country_val if country_val.present?
      end

      res.join(", ")
    else
      ""
    end
  end

  # Render a text field that is part of compound address.
  #----------------------------------------------------------------------------
  def address_field(form, object, attribute, extra_styles, edit = false)
    hint = "#{t(attribute)}..."
    if edit
      form.text_field(attribute,
                      style:   "margin-top: 6px; #{extra_styles}",
                      placeholder: hint
      )
    else
      if object.send(attribute).present?
        object.send(attribute)
      end
    end
  end

  def state_select()
    # collection_select(:post, :author_id, Account.find(:all), :id, :name)
    # collection_select :account, :id, accounts, :id, :name, options,
    #                   :"data-placeholder" => t(:select_an_account),
    #                   :"data-url" => auto_complete_accounts_path(format: 'json'),
    #                   :"data-chosen" => auto_complete_accounts_path(format: 'json'),
    #                   style: "width:230px;display:none; vertical-align: bottom",
    #                   class: 'ajax_chosen'
  end
end
