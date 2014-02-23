namespace :scraper do

  task :toronto_rinks, [:rink_id_range, :sleep_interval] => :environment do |t, args|
    args.with_defaults sleep_interval: 30
    rink_id_range = if args[:rink_id_range] 
      first_id, last_id = args[:rink_id_range].split("-").map(&:to_i)
      last_id ||= first_id
      Range.new first_id, last_id
    else
      nil
    end

    TorontoCityRinkScraper.logger = Logger.new(STDOUT)
    scraper = TorontoCityRinkScraper.new(sleep_interval: args[:sleep_interval],
                                         rink_ids: rink_id_range)
    scraper.execute
  end

end