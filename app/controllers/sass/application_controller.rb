class Sass::ApplicationController < ApplicationController
  # before_action :set_sass, only: [:show, :edit, :update, :destroy]


  # GET /sasses/1
  def signup
    begin
      @subscriber = Subscriber.new
    rescue => ex
      puts "TTT: " + "SIGNUP" + ex.message.to_s
    end

    render "signup", :layout => "layouts/sass/empty"
  end

  # POST /sasses
  def create
    domain = sass_params[:domain]
    res = create_tenant(domain)
    if res
      redirect_to login_url(subdomain:domain)
    else
      render :signup
    end
  end

  def create_tenant(domain)
    sass_params[:email] = sass_params[:email] || (domain + "@gmail.com")
    @subscriber = Subscriber.new(sass_params)
    puts "TTT: " + @subscriber.inspect

    if @subscriber.valid?
      @subscriber.save
      # create a schema with registered tenant
      Apartment::Tenant.create(domain)
      Apartment::Tenant.switch!(domain)

      add_admin_info(sass_params[:name], sass_params[:password], sass_params[:email])
      create_domain(domain)
      true
    else
      false
    end

  end

  def create_domain(domain)
    # create a domain with registered domain
    # Nothing in development
  end


  def add_admin_info(username, password, email)
    if username && password && email
      User.reset_column_information # Reload the class since we've added new fields in migrations.
      user = User.find_by_username(username) || User.new
      user.update_attributes(username: username, password: password, email: email)
      user.update_attribute(:admin, true) # Mass assignments don't work for :admin because of the attr_protected
      user.update_attribute(:suspended_at, nil) # Mass assignments don't work for :suspended_at because of the attr_protected
      puts "Admin user has been created."
    else
      puts "TTT: " + "SOMETHING WRONG:" + [username, password, email].inspect
    end
  end

  # PATCH/PUT /sasses/1
  def update
    if @admin_subscriber.update(sass_params)
      redirect_to sass_subscriber_path(@admin_subscriber), notice: 'Sass was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sasses/1
  def destroy
    # todo: drop schema
    # todo: delete record
  end



  private
    # Only allow a trusted parameter "white list" through.
    def sass_params
      params[:subscriber].permit!
    end
end
