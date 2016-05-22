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

  it_should_behave_like "create_common" do
    let(:model) { :account }
    let(:success_data) { @account = FactoryGirl.create(:account); @account }
    let(:error_data) { FactoryGirl.build(:account, name: nil) }
  end
end
