#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetch an agency overview and list its sub-agencies.
# Run: bundle exec ruby examples/agency_overview.rb

require 'bundler/setup'
require 'usaspending'

# Treasury Department = toptier_code "020"
overview = USAspending.agency.overview('020', fiscal_year: 2025)

puts "Agency:              #{overview['name']}"
puts "Budget Authority:    $#{(overview['budget_authority_amount'].to_f / 1e9).round(1)}B"
puts "Obligated:           $#{(overview['total_obligated_amount'].to_f / 1e9).round(1)}B"
puts "Congressional Just.: #{overview['congressional_justification_url']}"

puts "\nSub-agencies:"
subs = USAspending.agency.sub_agencies('020', fiscal_year: 2025, limit: 5)
subs.each do |sub|
  obligated = (sub['total_obligations'].to_f / 1e9).round(2)
  puts "  #{sub['name'].ljust(45)} $#{obligated}B"
end
