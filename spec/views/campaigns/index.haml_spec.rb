# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/campaigns/index" do
  include CampaignsHelper

  before do
    view.lookup_context.prefixes << 'entities'
    assign :per_page, Campaign.per_page
    assign :sort_by,  Campaign.sort_by
    assign :ransack_search, Campaign.search
    assign :campaign_status_total, {}
    login_and_assign
  end

  it_should_behave_like "index_list" do
    let(:model) { :campaign }
    let(:data) { [FactoryGirl.create(:campaign)].paginate }
  end

end
