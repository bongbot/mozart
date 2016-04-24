class Admin::SubscribersController < Admin::ApplicationController
  before_action :set_admin_subscriber, only: [:show, :edit, :update, :destroy]

  # GET /admin/subscribers
  def index
    @admin_subscribers = Subscriber.all
  end

  # GET /admin/subscribers/1
  def show
  end

  # GET /admin/subscribers/new
  def new
    @admin_subscriber = Subscriber.new
  end

  # GET /admin/subscribers/1/edit
  def edit
  end

  # POST /admin/subscribers
  def create
    @admin_subscriber = Subscriber.new(admin_subscriber_params)

    if @admin_subscriber.save
      redirect_to admin_subscriber_path(@admin_subscriber), notice: 'Subscriber was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/subscribers/1
  def update
    if @admin_subscriber.update(admin_subscriber_params)
      redirect_to @admin_subscriber, notice: 'Subscriber was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/subscribers/1
  def destroy
    @admin_subscriber.destroy
    redirect_to admin_subscribers_url, notice: 'Subscriber was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_subscriber
      @admin_subscriber = Subscriber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_subscriber_params
      params[:subscriber].permit!
    end
end
