class Sass::SessionsController < Devise::SessionsController
  def new
    logger.debugT "TTT: :" + sign_in_params.inspect
    # new login
    self.resource = resource_class.new(sign_in_params)
    # clean_up_passwords(resource)
    # yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

 def create
   logger.debugT "TTT: PARAM :" + params.require(resource_name.to_sym).inspect
   email = params.require(resource_name.to_sym)[:email]
   password = params.require(resource_name.to_sym)[:password]
   subscriber = resource_class.find_by_email(email)
   @error = "Không tồn tại email trên trong cơ sở dữ liệu" if subscriber == nil
   @error = "Tài khoản chưa kích hoạt" if (subscriber and subscriber.confirmed_at == nil)

   unless @error
     if subscriber.description == "admin"
       self.resource = warden.authenticate!(auth_options)
       sign_in(resource_name, resource)
       # login
       redirect_to sass_subscribers_path
     else
      redirect_to login_url(subdomain:subscriber.domain, password: password, email: email)
     end
   else
     self.resource = resource_class.new(sign_in_params)
     render :new
   end

  end
end

