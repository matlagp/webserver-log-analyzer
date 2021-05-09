require 'traffic_analyzer/address_views_counter'

describe TrafficAnalyzer::AddressViewsCounter do
  let(:counter) { TrafficAnalyzer::AddressViewsCounter.new }

  let(:address1) { '123.123.123.123' }
  let(:address2) { '212.212.212.212' }

  describe '#add_view' do
    context 'after initialization' do
      it 'has no entries' do
        expect(counter.count).to eq(0)
      end
    end

    context 'after adding views for one address' do
      it 'sums them up' do
        10.times do
          counter.add_view(address1)
        end

        expect(counter.count).to eq(1)
        expect(counter.first).to eq([address1, 10])
      end
    end

    context 'after adding views for multiple addresses' do
      it 'sums them up separately' do
        10.times do
          counter.add_view(address1)
        end
        8.times do
          counter.add_view(address2)
        end

        expect(counter.count).to eq(2)
        expect(counter.to_set).to eq([[address1, 10], [address2, 8]].to_set)
      end
    end
  end
end
