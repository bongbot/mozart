class Sass::Mailer < Devise::Mailer
  # helper :application # gives access to all helpers defined within `application_helper`.
  # include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'sass/mailer' # to make sure that your mailer uses the devise views
end