namespace :scraper do

  task :toronto_rinks, [:rink_id_range, :sleep_seconds] => :environment do |t, args|
    args.with_defaults sleep_seconds: 30
    rink_id_range = if args[:rink_id_range] 
      first_id, last_id = args[:rink_id_range].split("-").map(&:to_i)
      last_id ||= first_id
      Range.new first_id, last_id
    else
      nil
    end

    TorontoCityRinkScraper.logger = Logger.new(STDOUT)
    scraper = TorontoCityRinkScraper.new(sleep_seconds: args[:sleep_seconds],
                                         rink_ids: rink_id_range)
    scraper.execute
  end

end