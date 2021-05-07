module TrafficAnalyzer
  class Summary
    def initialize(log)
      @log = log
    end

    def views
      sites_with_views = parse_log
      sites_with_views.map { |site, views| SiteViewsCounter.new(site, views) }
                      .sort_by(&:views)
                      .reverse
    end

    private

    def parse_log
      @log.each_line.inject(Hash.new(0)) do |acc, line|
        words = line.split
        raise LogParsingError, "Malformed line. Expected 2 words, got #{words.length}." unless words.length == 2

        site, _address = words
        acc[site] += 1
        acc
      end
    end
  end
end
