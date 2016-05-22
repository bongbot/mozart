# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/accounts/create" do
  include AccountsHelper

  before do
    login_and_assign
  end

  # Note: [Create Account] is only called from Accounts index. Unlike other
  # core object Account partial is not embedded.
  describe "create success" do
    before do
      assign(:account, @account = FactoryGirl.create(:account))
      assign(:accounts, [@account].paginate)
      assign(:account_category_total, Hash.new(1))
      render template: 'accounts/js/create', formats: [:js]
    end

    it "should redirect to index or back to resource page if successful" do
      expect(rendered).to include("window.location.href")
    end
  end

  describe "create failure" do
    it "should re-render [create] template in :create_account div" do
      assign(:account, FactoryGirl.build(:account, name: nil)) # make it invalid
      assign(:users, [current_user])

      render template: 'accounts/js/create', formats: [:js]
      expect(rendered).to include("#edit_account")
      expect(rendered).to include(%/$('#edit_account').effect("shake"/)
    end
  end
end
