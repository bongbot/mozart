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

  it_should_behave_like "destroy_common" do
    let(:model) { :account }
  end
end
