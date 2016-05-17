# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchController do
  before do
    require_user
    @tasks = [FactoryGirl.create(:task, user: current_user, name: "campain")]
  end

  # POST /search
  #----------------------------------------------------------------------------
  describe "responding to POST search" do
    it "should render search result with found campaign" do
      post :search, search:{keyword:""}
      expect(assigns[:entities]).to eq(@tasks)
      expect(response).to render_template("search/search")
    end

    it "should show correct count result with found lead", :count => true  do
      @leads = [FactoryGirl.create(:lead, user: current_user)]

      post :search, search:{keyword:""}
      lead_count = assigns[:result].find{|_| _[:key] == :lead}
      expect(lead_count[:count]).to eq(1)
      expect(response).to render_template("search/search")
    end
  end

  # GET /search_partial
  #----------------------------------------------------------------------------
  describe "responding to search partial" do
    it "should show all search result of target resource when changing tab" do
      @leads = [FactoryGirl.create(:lead, user: current_user)]

      xhr :get, :search_partial, {keyword:"", model: "lead"}
      expect(assigns[:entities]).to eq(@leads)
      expect(response).to render_template("search/js/search_partial")
    end

  end

end
