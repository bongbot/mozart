namespace :db do
  desc "TODO"

  task migrate_mozart_sass: :environment do
    ActiveRecord::Base.establish_connection MOZART_SASS
    ActiveRecord::Migrator.migrate("db/sass/")
  end

end
