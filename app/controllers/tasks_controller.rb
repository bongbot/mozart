# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class TasksController < ApplicationController
  before_action :require_user
  before_action :set_current_tab, only: [:index, :show]
  before_action :update_sidebar, only: :index

  # GET /tasks
  #----------------------------------------------------------------------------
  def index
    @view = view
    @tasks = Task.find_all_grouped(current_user, @view)

    respond_with @tasks do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @tasks.map(&:second).flatten }
      format.xml { render xml: @tasks, except: [:subscribed_users] }
    end
  end

  # GET /tasks/1
  #----------------------------------------------------------------------------
  def show
    @task = Task.tracked_by(current_user).find(params[:id])
    @bucket = Setting.unroll(:task_bucket)[1..-1] << [t(:due_specific_date, default: 'On Specific Date...'), :specific_time]
    @category = Setting.unroll(:task_category)
    respond_with(@task)
  end

  # GET /tasks/new
  #----------------------------------------------------------------------------
  def new
    @view = view
    @task = Task.new

    @bucket = Setting.unroll(:task_bucket)[1..-1] << [t(:due_specific_date, default: 'On Specific Date...'), :specific_time]
    @category = Setting.unroll(:task_category)
    get_related_model do |model, related, id|
      if related
        instance_variable_set("@asset", related)
      else
        @return = true
        respond_to_related_not_found(model)
      end
    end

    respond_custom(@task)
  end

  # GET /tasks/1/edit                                                      AJAX
  #----------------------------------------------------------------------------
  def edit
    @view = view
    @task = Task.tracked_by(current_user).find(params[:id])

    @bucket = Setting.unroll(:task_bucket)[1..-1] << [t(:due_specific_date, default: 'On Specific Date...'), :specific_time]
    @category = Setting.unroll(:task_category)
    @asset = @task.asset if @task.asset_id?

    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Task.tracked_by(current_user).find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_custom(@task)
  end

  # POST /tasks
  #----------------------------------------------------------------------------
  def create
    @view = view
    @task = Task.new(task_params) # NOTE: we don't display validation messages for tasks.

    @bucket = Setting.unroll(:task_bucket)[1..-1] << [t(:due_specific_date, default: 'On Specific Date...'), :specific_time]
    @category = Setting.unroll(:task_category)
    @asset = @task.asset if @task.asset_id?

    @task.save

    respond_custom(@task) do |_format|
    end
  end

  # PUT /tasks/1
  #----------------------------------------------------------------------------
  def update
    @view = view
    @task = Task.tracked_by(current_user).find(params[:id])

    @bucket = Setting.unroll(:task_bucket)[1..-1] << [t(:due_specific_date, default: 'On Specific Date...'), :specific_time]
    @category = Setting.unroll(:task_category)
    @asset = @task.asset if @task.asset_id?

    @task_before_update = @task.dup

    if @task.due_at && (@task.due_at < Date.today.to_time)
      @task_before_update.bucket = "overdue"
    else
      @task_before_update.bucket = @task.computed_bucket
    end

    respond_custom(@task) do |format|
      if @task.update_attributes(task_params)
        logger.debug "TTT: : #{@task.bucket.inspect}    /**#{__FILE__}:#{__LINE__}"

      end
    end
  end

  def reschedule
    @task = Task.tracked_by(current_user).find(params[:id])
    if @task.update_attributes(bucket: params[:bucket])
      @task.bucket = @task.computed_bucket
    else
      logger.debug "TTT: : #{"HANDLE FAILURE".inspect}    /**#{__FILE__}:#{__LINE__}"
    end
    respond_custom(@task)
  end

  # DELETE /tasks/1
  #----------------------------------------------------------------------------
  def destroy
    @view = view
    @task = Task.tracked_by(current_user).find(params[:id])
    @task.destroy

    # Make sure bucket's div gets hidden if we're deleting last task in the bucket.
    if Task.bucket_empty?(params[:bucket], current_user, @view)
      @empty_bucket = params[:bucket]
    end

    update_sidebar if called_from_index_page?
    respond_custom(@task)
  end

  # PUT /tasks/1/complete
  #----------------------------------------------------------------------------
  def complete
    @task = Task.tracked_by(current_user).find(params[:id])
    @task.update_attributes(completed_at: Time.now, completed_by: current_user.id) if @task
    # Make sure bucket's div gets hidden if it's the last completed task in the bucket.
    if Task.bucket_empty?(params[:bucket], current_user)
      @empty_bucket = params[:bucket]
    end
    update_sidebar unless params[:bucket].blank?
    respond_custom(@task)
  end

  # PUT /tasks/1/uncomplete
  #----------------------------------------------------------------------------
  def uncomplete
    @task = Task.tracked_by(current_user).find(params[:id])
    @task.update_attributes(completed_at: nil, completed_by: nil) if @task

    # Make sure bucket's div gets hidden if we're deleting last task in the bucket.
    if Task.bucket_empty?(params[:bucket], current_user, @view)
      @empty_bucket = params[:bucket]
    end

    update_sidebar
    respond_custom(@task)
  end

  # POST /tasks/auto_complete/query                                        AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # Ajax request to filter out a list of tasks.                            AJAX
  #----------------------------------------------------------------------------
  def filter
    @view = view

    update_session do |filters|
      if params[:checked].true?
        filters << params[:filter]
      else
        filters.delete(params[:filter])
      end
    end

    respond_custom(:tasks)
  end

  protected

  def task_params
    params[:task].permit!
  end

  private

  # Yields array of current filters and updates the session using new values.
  #----------------------------------------------------------------------------
  def update_session
    name = "filter_by_task_#{@view}"
    filters = (session[name].nil? ? [] : session[name].split(","))
    yield filters
    session[name] = filters.uniq.join(",")
  end

  # Collect data necessary to render filters sidebar.
  #----------------------------------------------------------------------------
  def update_sidebar
    @view = view
    @task_total = Task.totals(current_user, @view)

    # Update filters session if we added, deleted, or completed a task.
    if @task
      update_session do |filters|
        if @empty_bucket  # deleted, completed, rescheduled, or reassigned and need to hide a bucket
          filters.delete(@empty_bucket)
        elsif !@task.deleted_at && !@task.completed_at # created new task
          filters << @task.computed_bucket
        end
      end
    end

    # Create default filters if filters session is empty.
    name = "filter_by_task_#{@view}"
    unless session[name]
      filters = @task_total.keys.select { |key| key != :all && @task_total[key] != 0 }.join(",")
      session[name] = filters unless filters.blank?
    end
  end

  # Ensure view is allowed
  #----------------------------------------------------------------------------
  def view
    view = params[:view]
    views = Task::ALLOWED_VIEWS
    views.include?(view) ? view : views.first
  end
end
