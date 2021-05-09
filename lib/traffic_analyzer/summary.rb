# frozen_string_literal: true

require_relative 'address_views_map'
require_relative 'log_parsing_error'

module TrafficAnalyzer
  SiteViews = Struct.new(:site, :views)

  # Parses a webserver log to an AddressViewsMap object for
  # each site in that log. Allows for calculating views and
  # unique views for all sites by using AddressViewsMap for
  # each site.
  class Summary
    def initialize(log)
      @log = log
    end

    def views
      sites_with_visitors.map { |site, addresses_with_views| SiteViews.new(site, addresses_with_views.views) }
                         .sort_by(&:views)
                         .reverse
    end

    def unique_views
      sites_with_visitors.map { |site, addresses_with_views| SiteViews.new(site, addresses_with_views.unique_views) }
                         .sort_by(&:views)
                         .reverse
    end

    private

    def sites_with_visitors
      accumulator = Hash.new { |h, k| h[k] = AddressViewsMap.new }
      @sites_with_visitors ||= @log.each_line.with_object(accumulator) do |line, acc|
        site, address = parse_line(line)
        acc[site].add_view(address)
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
