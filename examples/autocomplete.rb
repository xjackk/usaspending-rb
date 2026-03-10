#!/usr/bin/env ruby
# frozen_string_literal: true

# Autocomplete examples — useful for building search UIs.
# Run: bundle exec ruby examples/autocomplete.rb

require 'bundler/setup'
require 'usaspending'

puts 'Recipient search for "Lockheed":'
USAspending.autocomplete.recipient('Lockheed', limit: 5).each do |r|
  puts "  #{r['recipient_name']}"
end

puts "\nNAICS codes matching \"software\":"
USAspending.autocomplete.naics('software', limit: 5).each do |r|
  puts "  #{r['naics_code']} — #{r['naics_description']}"
end

puts "\nAgencies matching \"Defense\":"
USAspending.autocomplete.awarding_agency('Defense', limit: 5).each do |r|
  puts "  #{r['toptier_agency']['name']}"
end
