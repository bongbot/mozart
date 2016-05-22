# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/accounts/update" do
  include AccountsHelper

  before do
    login_and_assign

    assign(:account, @account = FactoryGirl.create(:account, user: current_user))
    assign(:users, [current_user])
    assign(:account_category_total, Hash.new(1))
  end

  describe "no errors:" do
    before do
      controller.request.env["HTTP_REFERER"] = "http://localhost/accounts/123"
    end

    it "should flip render account and emit edit ok" do
      render template: "accounts/js/update", formats: [:js]
      # render template: "accounts/js/update", formats: [:js]
      expect(rendered).to include("account_#{@account.id}")
      expect(rendered).to include("crm.event.emit(EVENT_EDIT_OK);")
    end

    it "should update recently" do
      render template: "accounts/js/update", formats: [:js]
      expect(rendered).to include("$('#recently').replaceWith")
    end
  end # no errors

  describe "validation errors:" do
    before do
      @account.errors.add(:name)
    end

    it "should redraw the [edit_account] form and shake it" do
      render template: "accounts/js/update", formats: [:js]

      expect(rendered).to include("#edit_account")
      expect(rendered).to include(%/$('#edit_account').effect("shake"/)
      expect(rendered).to include('focus()')
      expect(rendered).to include("crm.event.emit(EVENT_EDIT_NG);")
    end
  end # errors
end
