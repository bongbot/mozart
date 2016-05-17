# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchController do
  before(:each) do

  end

  # GET /searchs
  #----------------------------------------------------------------------------
  describe "responding to POST index" do
    before do
      FactoryGirl.create(:campaign, user: current_user, name: "campain 1")
    end

    after do
      Time.zone = @timezone
    end

    it "should render search result with found created campaign" do
      post :search, search:{keyword:""}
      # puts "TTT:: " + assigns[:entities].inspect

      # expect(assigns[:tasks].values.flatten - @tasks.values.flatten).to eq([])
      expect(response).to render_template("search/search")
    end

  end

end
