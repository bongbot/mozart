# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

describe "/campaigns/_edit" do
  include CampaignsHelper

  before do |example|
    login_and_assign
    assign(:campaign, @campaign = FactoryGirl.create(:campaign))
    assign(:users, [current_user])
  end

  it "should render [edit campaign] form" do
    render

    expect(view).to render_template(partial: "campaigns/_top_section")
    expect(view).to render_template(partial: "campaigns/_objectives")
    expect(view).to render_template(partial: "_permissions")

    expect(view).to have_tag("form[class=edit_campaign]") do
      with_tag "input[type=hidden][id=campaign_user_id][value='#{@campaign.user_id}']"
    end
  end

  it_should_behave_like "background" do
    let(:model) { :campaign }
  end

end
