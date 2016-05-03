class Sass::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    password = self.resource.pwd
    yield resource if block_given?
    logger.debugT "TTT:ERROR : #{resource.errors.inspect}"
    if resource.errors.empty?
      domain = resource.domain
      if create_tenant(resource, password)
        redirect_to login_url(subdomain:domain)
      else
        render "confirm_error", :layout => false
      end
    else
      render "confirm_error", :layout => false
    end
  end

  def create_tenant(resource, password)
    begin
      domain = resource.domain
      email = resource.email
      name = resource.name

      # create a schema with registered tenant
      Apartment::Tenant.create(domain)
      Apartment::Tenant.switch!(domain)
      add_defautl_admin(name, password, email)

      create_domain_settings(domain)
      true
    rescue
      false
    end
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

end