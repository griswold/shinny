namespace :scraper do

  desc "synchronize the rinks database"
  task :rinks => :environment do
    Scraper.new.update_rinks
  end

  desc "synchronizes a rink"
  task :update_rink_details, [:rink_id] => :environment do |t, args|
    Scraper.new.update_rink_details(args.rink_id) 
  end

  desc "load all rink details"
  task :update_all_rink_details, [:min_id, :max_id, :sleep_interval] => :environment do |t, args|
    scraper = Scraper.new
    rinks = Rink.all
    rinks = rinks.where("id >= ?", args.min_id) if args.min_id.present?
    rinks = rinks.where("id <= ?", args.max_id) if args.max_id.present?

    sleep_interval = args.sleep_interval

    rinks.each do |rink|
      puts "Updating ##{rink.id}: #{rink.name}"
      scraper.update_rink_details(rink.id) 
      if sleep_interval
        puts "Resting for #{sleep_interval} seconds"
        sleep(sleep_interval.to_i)
      end
    end
  end

end