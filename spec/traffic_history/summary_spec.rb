# frozen_string_literal: true

require 'traffic_analyzer/summary'
require 'traffic_analyzer/log_parsing_error'

describe TrafficAnalyzer::Summary do
  let(:summary_with_empty_log) do
    log = StringIO.new
    TrafficAnalyzer::Summary.new(log)
  end

  let(:summary_with_correct_log_with_repetitions) do
    log = StringIO.new(%(
      /contact 543.910.244.9
      /about/2 444.701.448.1
      /about/2 836.973.694.4
      /about/2 178.129.98.4
      /about 126.318.035.038
      /about 126.318.035.038
      /about 126.318.035.038
      /about 111.213.112.13
    ).strip)
    TrafficAnalyzer::Summary.new(log)
  end

  let(:summary_with_log_with_too_long_line) do
    log = StringIO.new(%(
      /about 126.318.035.038
      /about/2 444.701.448.1 Too many words
      /about 126.318.035.038
    ).strip)
    TrafficAnalyzer::Summary.new(log)
  end

  let(:summary_with_log_with_too_short_line) do
    log = StringIO.new(%(
      /about 126.318.035.038
      /about/2
      /about 126.318.035.038
    ).strip)
    TrafficAnalyzer::Summary.new(log)
  end

  describe '#views' do
    context 'when given an empty log' do
      it 'returns an empty list' do
        expect(summary_with_empty_log.views).to eq([])
      end
    end

    context 'when given a correct log with repetitions' do
      it 'returns a list of SiteViews structs' do
        expect(summary_with_correct_log_with_repetitions.views).to all(be_a(TrafficAnalyzer::SiteViews))
      end

      it 'returns one SiteViews instance for each site' do
        views = summary_with_correct_log_with_repetitions.views

        expect(views.length).to eq(3)
        expect(views.map(&:site).to_set).to eq(['/about', '/about/2', '/contact'].to_set)
      end

      it 'sums up views for every site in a descending order' do
        views = summary_with_correct_log_with_repetitions.views

        expect([views[0].site, views[0].views]).to eq(['/about', 4])
        expect([views[1].site, views[1].views]).to eq(['/about/2', 3])
        expect([views[2].site, views[2].views]).to eq(['/contact', 1])
      end
    end

    context 'when given a malformed log' do
      it 'raises a LogParsingError when line has too many words' do
        expect { summary_with_log_with_too_long_line.views }.to raise_error(TrafficAnalyzer::LogParsingError, /got 5/)
      end

      it 'raises a LogParsingError when line has too few words' do
        expect { summary_with_log_with_too_short_line.views }.to raise_error(TrafficAnalyzer::LogParsingError, /got 1/)
      end
    end
  end

  describe '#unique_views' do
    context 'when given an empty log' do
      it 'returns an empty list' do
        expect(summary_with_empty_log.unique_views).to eq([])
      end
    end

    context 'when given a correct log with repetitions' do
      it 'returns a list of SiteViews structs' do
        expect(summary_with_correct_log_with_repetitions.unique_views).to all(be_a(TrafficAnalyzer::SiteViews))
      end

      it 'returns one SiteViewsinstance for each site' do
        views = summary_with_correct_log_with_repetitions.unique_views

        expect(views.length).to eq(3)
        expect(views.map(&:site).to_set).to eq(['/about', '/about/2', '/contact'].to_set)
      end

      it 'sums up unique views for every site in a descending order' do
        views = summary_with_correct_log_with_repetitions.unique_views

        expect([views[0].site, views[0].views]).to eq(['/about/2', 3])
        expect([views[1].site, views[1].views]).to eq(['/about', 2])
        expect([views[2].site, views[2].views]).to eq(['/contact', 1])
      end
    end

    context 'when given a malformed log' do
      it 'raises a LogParsingError when line has too many words' do
        expect do
          summary_with_log_with_too_long_line.unique_views
        end.to raise_error(TrafficAnalyzer::LogParsingError, /got 5/)
      end

      it 'raises a LogParsingError when line has too few words' do
        expect do
          summary_with_log_with_too_short_line.unique_views
        end.to raise_error(TrafficAnalyzer::LogParsingError, /got 1/)
      end
    end
  end
end
