# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/campaigns/update" do
  before do
    login_and_assign
    assign(:users, [current_user])
  end

  it_should_behave_like "update_common" do
    let(:model) { :campaign }
    let(:data) { FactoryGirl.create(:campaign, user: current_user) }
  end
end
