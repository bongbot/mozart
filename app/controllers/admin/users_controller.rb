# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Admin::UsersController < Admin::ApplicationController
  before_action "set_current_tab('admin/users')", only: [:index, :show]

  load_resource except: [:create]

  # GET /admin/users
  # GET /admin/users.xml                                                   HTML
  #----------------------------------------------------------------------------
  def index
    @users = get_users(page: params[:page])
    respond_custom(@users)
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  #----------------------------------------------------------------------------
  def show
    respond_custom(@user)
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml                                               AJAX
  #----------------------------------------------------------------------------
  def new
    puts "TTT:USER: " + @user.inspect
    respond_custom(@user)
  end

  # GET /admin/users/1/edit                                                AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = User.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_custom(@user)
  end

  # POST /admin/users
  # POST /admin/users.xml                                                  AJAX
  #----------------------------------------------------------------------------
  def create
    params[:user][:password_confirmation] = nil if params[:user][:password_confirmation].blank?
    @user = User.new(user_params)
    @user.save_without_session_maintenance

    respond_custom(@user)
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def update
    params[:user][:password_confirmation] = nil if params[:user][:password_confirmation].blank?
    @user = User.find(params[:id])
    @user.attributes = user_params
    @user.save_without_session_maintenance

    respond_custom(@user)
  end

  # GET /admin/users/1/confirm                                             AJAX
  #----------------------------------------------------------------------------
  def confirm
    respond_custom(@user)
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml                                              AJAX
  #----------------------------------------------------------------------------
  def destroy
    flash[:warning] = t(:msg_cant_delete_user, @user.full_name) unless @user.destroy

    respond_custom(@user)
  end

  # POST /users/auto_complete/query                                        AJAX
  #----------------------------------------------------------------------------
  # Handled by Admin::ApplicationController :auto_complete

  # PUT /admin/users/1/suspend
  # PUT /admin/users/1/suspend.xml                                         AJAX
  #----------------------------------------------------------------------------
  def suspend
    @user.update_attribute(:suspended_at, Time.now) if @user != current_user

    respond_custom(@user)
  end

  # PUT /admin/users/1/reactivate
  # PUT /admin/users/1/reactivate.xml                                      AJAX
  #----------------------------------------------------------------------------
  def reactivate
    @user.update_attribute(:suspended_at, nil)

    respond_custom(@user)
  end

  protected

  def user_params
    params[:user].permit(
      :admin,
      :username,
      :email,
      :first_name,
      :last_name,
      :title,
      :company,
      :alt_email,
      :phone,
      :mobile,
      :aim,
      :yahoo,
      :google,
      :skype,
      :password,
      :password_confirmation,
      group_ids: []
    )
  end

  private

  #----------------------------------------------------------------------------
  def get_users(options = {})
    self.current_page  = options[:page] if options[:page]
    self.current_query = params[:query] if params[:query]

    @search = klass.search(params[:q])
    @search.build_grouping unless @search.groupings.any?

    wants = request.format
    scope = User.by_id
    scope = scope.merge(@search.result)
    scope = scope.text_search(current_query)      if current_query.present?
    scope = scope.paginate(page: current_page) if wants.html? || wants.js? || wants.xml?
    scope
  end
end
