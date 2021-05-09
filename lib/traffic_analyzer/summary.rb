module TrafficAnalyzer
  class Summary
    def initialize(log)
      @log = log
    end

    def views
      sites_with_views.map { |site, counter| SiteViewsCounter.new(site, counter.views) }
                      .sort_by(&:views)
                      .reverse
    end

    def unique_views
      sites_with_views.map { |site, counter| SiteViewsCounter.new(site, counter.unique_views) }
                      .sort_by(&:views)
                      .reverse
    end

    private

    def sites_with_views
      accumulator = Hash.new { |h, k| h[k] = AddressViewsCounter.new }
      @sites_with_views ||= @log.each_line.inject(accumulator) do |acc, line|
        site, address = parse_line(line)
        acc[site].add_view(address)
        acc
      end
    end

    def parse_line(line)
      words = line.split

      unless words.length == 2
        raise LogParsingError,
              "Malformed line #{@log.lineno}: expected 2 words, got #{words.length}."
      end

      words
    end
  end
end
