# frozen_string_literal: true

require_relative 'lib/traffic_analyzer/summary'

if ARGV.empty?
  puts('Missing argument. Usage: ruby traffic_analyzer.rb path_to_webserver.log')
  exit
end

File.open(ARGV.shift) do |log|
  summary = TrafficAnalyzer::Summary.new(log)

  summary.views.each do |site_with_views|
    puts("#{site_with_views.site}: #{site_with_views.views} visits")
  end

  puts("\n")

  summary.unique_views.each do |site_with_views|
    puts("#{site_with_views.site}: #{site_with_views.views} unique views")
  end
end
