class Admin::SettingsController < Admin::ApplicationController
  before_action "set_current_tab('admin/settings')", only: [:index]
  before_action :set_admin_setting, only: [:show, :edit, :update, :destroy]

  # GET /admin/settings
  def index
    @all_setting_groups = []
    task_category_settings = Setting.where(:name => "task_category")
    @all_setting_groups << {name: "Task Category", value:task_category_settings, group_type: "task_category"}
    dues_settings = Setting.where(:name => "due")
    @all_setting_groups << {name: "Due type", value:dues_settings, group_type: "due"}
  end

  # GET /admin/settings/1
  def show
  end

  # GET /admin/settings/new
  def new
    @group_type = params[:group_type]
    @admin_setting = Setting.new
  end

  # GET /admin/settings/1/edit
  def edit
    @group_type = @admin_setting.name
  end

  # POST /admin/settings
  def create
    @admin_setting = Setting.new(admin_setting_params)

    if @admin_setting.save
      redirect_to admin_setting_path(@admin_setting), notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/settings/1
  def update
    if @admin_setting.update(admin_setting_params)
      redirect_to admin_setting_path(@admin_setting), notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/settings/1
  def destroy
    @admin_setting.destroy
    redirect_to admin_settings_url, notice: 'Setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_setting
      @admin_setting = Setting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_setting_params
      params[:setting].permit(:name, :value)
    end
end
