class Sass::RegistrationsController < Devise::RegistrationsController
  def new
    # include ::CustomTest
    logger.debugT "TTT: : HAH"
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.pwd = sign_up_params[:password]
    begin
      resource.save
    rescue Exception => ex
      logger.info "III:ERROR: " + ex.inspect
    end

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        logger.debugT "TTT: :" + "resource active"
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        logger.debugT "TTT: :" + "resource inactive"
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def success
    @resource = resource_class.find(params[:id])
  end

  def after_inactive_sign_up_path_for(resource)
    success_path(resource)
  end

  private
  def sign_up_params
    params.require(:subscriber).permit(:name, :email, :password, :password_confirmation, :image, :domain)
  end

end