# frozen_string_literal: true

require 'traffic_analyzer/address_views_map'

describe TrafficAnalyzer::AddressViewsMap do
  let(:map) { TrafficAnalyzer::AddressViewsMap.new }

  let(:address1) { '123.123.123.123' }
  let(:address2) { '212.212.212.212' }

  describe '#add_view' do
    context 'after initialization' do
      it 'has no entries' do
        expect(map.count).to eq(0)
      end
    end

    context 'after adding views for one address' do
      it 'sums them up' do
        10.times do
          map.add_view(address1)
        end

        expect(map.count).to eq(1)
        expect(map.first).to eq([address1, 10])
      end
    end

    context 'after adding views for multiple addresses' do
      it 'sums them up separately' do
        10.times do
          map.add_view(address1)
        end
        8.times do
          map.add_view(address2)
        end

        expect(map.count).to eq(2)
        expect(map.to_set).to eq([[address1, 10], [address2, 8]].to_set)
      end
    end
  end
end
