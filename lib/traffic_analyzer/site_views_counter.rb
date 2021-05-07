module TrafficAnalyzer
  class SiteViewsCounter
    attr_accessor :site, :views

    def initialize(site, views)
      @site = site
      @views = views
    end
  end
end
