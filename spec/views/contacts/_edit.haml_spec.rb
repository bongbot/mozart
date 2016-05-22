# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contacts/_edit" do
  include ContactsHelper

  before do
    login_and_assign
    assign(:account, @account = FactoryGirl.create(:account))
    assign(:accounts, [@account])
    assign(:users, [current_user])
    assign(:contact, FactoryGirl.create(:contact))
  end

  it "should render [edit contact] form" do
    assign(:contact, @contact = FactoryGirl.create(:contact))

    render
    expect(view).to render_template(partial: "contacts/_top_section")
    expect(view).to render_template(partial: "contacts/_extra")
    expect(view).to render_template(partial: "shared/_web")
    expect(view).to render_template(partial: "_permissions")

    expect(rendered).to have_tag("form[class=edit_contact]") do
      with_tag "input[type=hidden][id=contact_user_id][value='#{@contact.user_id}']"
    end
  end

  # it "should pick default assignee (Myself)" do
  #   assign(:users, [current_user])
  #   assign(:contact, FactoryGirl.create(:contact, assignee: nil))
  #
  #   render
  #   expect(rendered).to have_tag("select[id=contact_assigned_to]") do |options|
  #     expect(options.to_s).not_to include(%(selected="selected"))
  #   end
  # end
  #
  it "should show correct assignee" do
    @user = FactoryGirl.create(:user)
    assign(:users, [current_user, @user])
    assign(:contact, FactoryGirl.create(:contact, assignee: @user))

    render partial: "contacts/edit", locals: {edit: true}
    expect(rendered).to have_tag("select[id=contact_assigned_to]") do |_options|
      with_tag "option[selected=selected]"
      with_tag "option[value='#{@user.id}']"
    end
  end

  it_should_behave_like "background" do
    let(:model) { :contact }
  end
end
