class Sass::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    password = self.resource.pwd
    yield resource if block_given?
    logger.debugT "III:ERROR : #{resource.errors.inspect}"
    if resource.errors.empty? || !tenant_exist?(self.resource.domain)
      @resource = self.resource
      create_tenant(resource, password)
      render :waiting, :layout => "empty"
    else
      if (self.resource and self.resource.confirmed_at)
        # if account already confirmed, redirect to login path
        recdirect_to_login(self.resource)
      else
        render :confirm_error, :layout => "empty"
      end
    end
  end

  def check_finish
    # session.
    render :json => {state: session[:tenant_state]}
  end

  def create_tenant(resource, password)
    session[:tenant_state] = :waiting
    Thread.new do
      begin
        Account.transaction do
          domain = resource.domain
          email = resource.email
          name = resource.name

          # create a schema with registered tenant
          Apartment::Tenant.create(domain)
          Apartment::Tenant.switch!(domain)
          add_defautl_admin(name, password, email)

          create_domain_settings(domain)
          session[:tenant_state] = :success
        end
      rescue
        session[:tenant_state] = :error
        # if resouce has been save, rollback

      end
    end
    # fork to another thread
  end

  def create_domain_settings(domain)
    # create a domain with registered domain
    # Nothing in development
  end


  def add_defautl_admin(username, password, email)
    if username && password && email
      User.reset_column_information # Reload the class since we've added new fields in migrations.
      user = User.find_by_username(username) || User.new
      user.update_attributes(username: username, password: password, email: email)
      user.update_attribute(:admin, true) # Mass assignments don't work for :admin because of the attr_protected
      user.update_attribute(:suspended_at, nil) # Mass assignments don't work for :suspended_at because of the attr_protected
      logger.debug "TTT: : Admin user has been created."
    else
      logger.debug "TTT: " + "SOMETHING WRONG:" + [username, password, email].inspect
    end
  end

  private
  def recdirect_to_login(resource)
    redirect_to login_url(subdomain:resource.domain)
  end

  def tenant_exist?(tenant)
    begin
      Apartment::Tenant.switch!(tenant)
      true
    rescue Exception => ex
      false
    end
  end

end