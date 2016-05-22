# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/index" do
  include AccountsHelper

  before do
    view.lookup_context.prefixes << 'entities'
    assign :per_page, Account.per_page
    assign :sort_by,  Account.sort_by
    assign :ransack_search, Account.search
    assign :model_name, "account"
    assign :account_category_total, {}
    login_and_assign
  end

  it "should render account name" do
    assign(:accounts, [FactoryGirl.create(:account, name: 'New Media Inc'), FactoryGirl.create(:account)].paginate)
    render
    expect(rendered).to have_tag('a', text: "New Media Inc")
  end

  it_should_behave_like "index_list" do
    let(:model) { :account }
    let(:data) { [FactoryGirl.create(:account), FactoryGirl.create(:account)].paginate }
  end
end
