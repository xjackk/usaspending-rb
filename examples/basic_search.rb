#!/usr/bin/env ruby
# frozen_string_literal: true

# Search for federal contracts and print the top results.
# Run: bundle exec ruby examples/basic_search.rb

require 'bundler/setup'
require 'usaspending'

response = USAspending.awards.search(
  filters: {
    award_type_codes: %w[A B C D],
    time_period: [{ start_date: '2024-10-01', end_date: '2025-09-30' }]
  },
  fields: ['Award ID', 'Recipient Name', 'Award Amount', 'Awarding Agency'],
  sort: 'Award Amount',
  limit: 10
)

puts "Found #{response.total_count} total awards (showing top #{response.size}):\n\n"

response.each do |award|
  amount = format('$%<amt>.2f', amt: award['Award Amount'].to_f)
  puts "  #{amount.rjust(20)}  #{award['Recipient Name']}"
  puts "  #{' ' * 20}  #{award['Awarding Agency']} — #{award['Award ID']}\n\n"
end
