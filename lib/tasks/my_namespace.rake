namespace :my_namespace do
  require 'rake'

  desc "TODO"
  task create_tenant: :environment do
    Apartment::Tenant.create('tran')
    Apartment::Tenant.create('manh')
    Apartment::Tenant.create('cuong')
  end

  desc "TODO"
  task create_default_tenant: :environment do
    config   = Rails.configuration.database_configuration
    db = config[Rails.env]["database"]
    puts db
    Apartment::Tenant.create(db)
  end

  desc "migrate"
  task migrate_tenant: :environment do
    # ENV["VERSION"] = "20150427131956";
    # Apartment::Tenant.switch!('tran')
    # Rake::Task["db:migrate:up"].invoke
  end

  desc "initial data"
  task initial_tenant: :environment do
    # Apartment::Tenant.switch!('tran')
    # Rake::Task["ffcrm:setup:admin"].invoke()

    # Apartment::Tenant.switch!('manh')
    # Rake::Task["ffcrm:setup:admin"].invoke()

    #
    Apartment::Tenant.switch!('cuong')
    Rake::Task["ffcrm:setup:admin"].invoke()

    end

  desc "demo data"
  task demo_tenant: :environment do
    # Apartment::Tenant.switch!('tran')
    # Rake::Task["ffcrm:setup:admin"].invoke()

    # Apartment::Tenant.switch!('manh')
    # Rake::Task["ffcrm:setup:admin"].invoke()

    #
    Apartment::Tenant.switch!('cuong')
    Rake::Task["ffcrm:demo:load"].invoke()

  end

end
