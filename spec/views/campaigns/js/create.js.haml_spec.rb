# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/campaigns/create" do
  before do
    login_and_assign
  end

  it_should_behave_like "create_common" do
    let(:model) { :campaign }
    let(:success_data) { @campaign = FactoryGirl.create(:campaign); @campaign }
    let(:error_data) { FactoryGirl.build(:campaign, name: nil) }
  end

end
