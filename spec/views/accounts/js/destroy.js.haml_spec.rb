# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/accounts/destroy" do
  include AccountsHelper

  before do
    login_and_assign
    assign(:account, @account = FactoryGirl.create(:account))
    assign(:accounts, [@account].paginate)
    assign(:account_category_total, Hash.new(1))
    render template: 'accounts/js/destroy'
  end

  it "should blind up destroyed account partial" do
    expect(rendered).to include("slideUp")
  end

  it "should update accounts pagination" do
    expect(rendered).to include("#paginate")
  end

  it "should update accounts toolbar" do
    expect(rendered).to include("#toolbar")
  end
end
