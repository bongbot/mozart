# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/contacts/destroy" do
  include ContactsHelper

  before do
    login_and_assign
    assign(:contact, @contact = FactoryGirl.create(:contact))
    assign(:contacts, [@contact].paginate)
  end

  it_should_behave_like "destroy_common" do
    let(:model) { :contact }
  end
end
