#!/usr/bin/env ruby
# frozen_string_literal: true

# Look up total federal spending in a congressional district.
# Run: bundle exec ruby examples/district_spending.rb

require 'bundler/setup'
require 'usaspending'

state    = 'VA'
district = '08'
fy       = 2025

response = USAspending.spending.for_district(
  state_abbr: state,
  district: district,
  fiscal_years: [fy]
)

puts "Federal spending in #{state}-#{district} (FY#{fy}):\n\n"

if response.empty?
  puts '  No data available for this district/year.'
else
  response.results
          .sort_by { |r| -r['aggregated_amount'].to_f }
          .first(10)
          .each do |result|
    amount = (result['aggregated_amount'].to_f / 1e6).round(1)
    puts "  #{result['display_name'].to_s.ljust(30)} $#{amount}M"
  end
end
