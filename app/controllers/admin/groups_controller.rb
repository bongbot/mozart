# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Admin::GroupsController < Admin::ApplicationController
  before_action "set_current_tab('admin/groups')", only: [:index, :show]

  load_resource

  # GET /groups
  #----------------------------------------------------------------------------
  def index
    @groups = @groups.unscoped.paginate(page: params[:page])
    respond_custom(@group)
  end

  # GET /groups/1
  #----------------------------------------------------------------------------
  def show
    respond_custom(@group)
  end

  # GET /groups/new
  #----------------------------------------------------------------------------
  def new
    respond_custom(@group)
  end

  # GET /groups/1/edit
  #----------------------------------------------------------------------------
  def edit
    respond_custom(@group)
  end

  # POST /groups
  #----------------------------------------------------------------------------
  def create
    @group.attributes = group_params
    @group.save

    respond_custom(@group)
  end

  # PUT /groups/1
  #----------------------------------------------------------------------------
  def update
    @group.update_attributes(group_params)

    respond_custom(@group)
  end

  # DELETE /groups/1
  #----------------------------------------------------------------------------
  def destroy
    @group.destroy

    respond_custom(@group)
  end

  protected

  def group_params
    params[:group].permit!
  end
end
