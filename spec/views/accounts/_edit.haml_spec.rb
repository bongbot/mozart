# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/accounts/_edit" do
  include AccountsHelper

  before do
    login_and_assign
    assign(:account, @account = FactoryGirl.create(:account))
    assign(:users, [current_user])
  end

  it "should render [edit account] form" do
    render

    expect(view).to render_template(partial: "_top_section")
    expect(view).to render_template(partial: "_contact_info")
    expect(view).to render_template(partial: "_permissions")

    expect(rendered).to have_tag("form[class=edit_account]") do |form|
      expect(form).to have_tag "input[type=hidden][id=account_user_id][value='#{@account.user_id}']"
    end
  end

  it_should_behave_like "background" do
    let(:model) { :account }
  end
end
