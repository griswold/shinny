namespace :scraper do

  desc "synchronize the rinks database"
  task :rinks => :environment do
    Scraper.new.update_rinks
  end

  desc "synchronizes a rink"
  task :update_rink_details, [:rink_id] => :environment do |t, args|
    Scraper.new.update_rink_details(args.rink_id) 
  end

end