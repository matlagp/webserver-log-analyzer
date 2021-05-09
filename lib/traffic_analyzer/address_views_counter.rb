module TrafficAnalyzer
  class AddressViewsCounter
    include Enumerable

    def initialize
      @addresses_with_views = Hash.new(0)
    end

    def add_view(address)
      @addresses_with_views[address] += 1
    end

    def each(&block)
      @addresses_with_views.each { |address, views| block.call(address, views) }
    end

    def views
      @addresses_with_views.each_value.inject(0) { |sum, address_views| sum + address_views}
    end

    def unique_views
      @addresses_with_views.length
    end
  end
end
