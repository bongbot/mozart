class Sass::SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    # clean_up_passwords(resource)
    # yield resource if block_given?
    puts "TTT:RESOURCE: " + serialize_options(resource).inspect
    respond_with(resource, serialize_options(resource).merge({:layout => "sass/empty"}))
  end

 def create
   logger.debugT "TTT: PARAM :" + params.require(resource_name.to_sym).inspect
   email = params.require(resource_name.to_sym)[:email]
   password = params.require(resource_name.to_sym)[:password]
   subscriber = resource_class.find_by_email(email)

   unless subscriber
     @error = "Không tồn tại email trên trong cơ sở dữ liệu"
   else
     if !subscriber.confirmed_at
       @error = "Tài khoản chưa kích hoạt"
     end
   end

   unless @error
     if subscriber.description == "admin"
       self.resource = warden.authenticate!(auth_options)
       sign_in(resource_name, resource)
       # login
       redirect_to sass_subscribers_path
     else
      redirect_to sasslogin_url(subdomain:subscriber.domain, "authentication[password]": password, "authentication[email]": email)
     end
   else
     self.resource = resource_class.new(sign_in_params)
     render :new
   end

  end
end

