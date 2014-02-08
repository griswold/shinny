namespace :scraper do

  desc "synchronize the rinks database"
  task :rinks => :environment do
    Scraper.new.update_rinks
  end

end