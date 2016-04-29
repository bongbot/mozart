class Sass::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    render :layout => "sass/empty"
  end
end