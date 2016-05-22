# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/accounts/edit" do
  include AccountsHelper

  before do
    login_and_assign
    assign(:account, @account = FactoryGirl.create(:account, user: current_user))
    assign(:users, [current_user])
  end

  it "should show [edit account] form" do
    params[:cancel] = "false"

    render template: "accounts/js/edit", formats: [:js]
    expect(rendered).to include("edit_account")
    expect(rendered).to include("crm.event.emit(EVENT_EDIT_START);")
  end
end
