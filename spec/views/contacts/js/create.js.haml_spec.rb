# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/contacts/create" do
  include ContactsHelper

  before do
    login_and_assign
    @account = FactoryGirl.create(:account)
  end

  it_should_behave_like "create_common" do
    let(:model) { :contact }
    let(:success_data) { @contact = FactoryGirl.create(:contact); @contact }
    let(:error_data) { FactoryGirl.build(:contact, first_name: nil) }
  end
end
