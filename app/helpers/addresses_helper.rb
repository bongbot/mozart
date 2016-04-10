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
end
