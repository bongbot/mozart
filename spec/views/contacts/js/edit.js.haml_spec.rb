# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/contacts/edit" do
  include ContactsHelper

  before do
    login_and_assign
    assign(:contact, @contact = FactoryGirl.create(:contact, user: current_user))
    assign(:users, [current_user])
    assign(:account, @account = FactoryGirl.create(:account))
    assign(:accounts, [@account])
  end

  it_should_behave_like "edit_js_common" do
    let(:model) { :contact }
  end
end
