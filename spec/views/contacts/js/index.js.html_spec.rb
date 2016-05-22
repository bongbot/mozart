# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/contacts/index" do
  include ContactsHelper

  before do
    login_and_assign
  end

  it_should_behave_like "index_js_common" do
    let(:model) { :contact }
    let(:data) { [FactoryGirl.create(:contact, id: 42)].paginate }
  end
end
