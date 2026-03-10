#!/usr/bin/env ruby
# frozen_string_literal: true

# Live smoke test — hits the real USAspending.gov API to verify our gem works
# Run: bundle exec ruby examples/live_smoke_test.rb

require 'bundler/setup'
require 'usaspending'
require 'logger'

USAspending.configure do |config|
  config.timeout = 60
  config.logger  = Logger.new($stdout, level: Logger::WARN)
end

PASS = "\e[32m✓\e[0m"
FAIL = "\e[31m✗\e[0m"
WARN = "\e[33m⚠\e[0m"

results = []

def test(name)
  print "  Testing #{name}... "
  result = yield
  puts "#{PASS} OK"
  [name, :pass, result]
rescue StandardError => e
  puts "#{FAIL} #{e.class}: #{e.message}"
  [name, :fail, e]
end

puts "\n═══════════════════════════════════════════════════"
puts ' USAspending Gem — Live Smoke Test'
puts "═══════════════════════════════════════════════════\n\n"

# ─── 1. Reference data (needed to bootstrap everything) ───
puts '▸ Reference Data'

results << test('Top-tier agencies list') do
  r = USAspending.agency.list
  agencies = r.results
  raise 'No agencies returned' if agencies.empty?

  puts "\n    → #{agencies.size} agencies (first: #{agencies.first['agency_name']})"
  r
end

results << test('DEF codes (disaster/emergency fund codes)') do
  r = USAspending.references.def_codes
  raise 'No def codes' if r.results.empty?

  puts "\n    → #{r.results.size} DEF codes"
  r
end

results << test('Submission periods') do
  r = USAspending.references.submission_periods
  raise 'No submission periods' if r.results.empty?

  latest = r.results.last
  puts "\n    → Latest: FY#{latest['submission_fiscal_year']} P#{latest['submission_fiscal_month']}"
  r
end

results << test('Glossary') do
  r = USAspending.references.glossary
  raise 'Empty glossary' if r.results.empty?

  puts "\n    → #{r.results.size} glossary terms"
  r
end

# ─── 2. Agency deep-dive (ThePublicTab core feature) ───
puts "\n▸ Agency Deep-Dive (Treasury = 020)"
toptier = '020'

results << test('Agency overview') do
  r = USAspending.agency.overview(toptier, fiscal_year: 2024)
  name = r.raw['agency_name'] || r.raw['name']
  raise 'No agency name in response' unless name

  puts "\n    → #{name}: $#{(r.raw['total_obligated_amount'].to_f / 1e9).round(1)}B obligated"
  r
end

results << test('Agency budgetary resources') do
  r = USAspending.agency.budgetary_resources(toptier)
  puts "\n    → Keys: #{r.raw.keys.join(', ')}"
  r
end

results << test('Agency sub-agencies') do
  r = USAspending.agency.sub_agencies(toptier, fiscal_year: 2024, limit: 5)
  puts "\n    → #{r.results.size} sub-agencies returned"
  r
end

results << test('Agency obligations by award category') do
  r = USAspending.agency.obligations_by_award_category(toptier, fiscal_year: 2024)
  puts "\n    → Keys: #{r.raw.keys.join(', ')}"
  r
end

# ─── 3. Award search (the bread and butter) ───
puts "\n▸ Award Search"

results << test('Search contracts (type A-D), limit 5') do
  r = USAspending.awards.search(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 5
  )
  raise 'No results' if r.results.empty?

  first = r.results.first
  puts "\n    → #{r.results.size} awards, first: #{first['Recipient Name']} — $#{first['Award Amount']}"
  puts "    → has_next_page?: #{r.has_next_page?}"
  r
end

results << test('Search grants (type 02-05), limit 3') do
  # NOTE: award_type_codes must be from a single group. 02-05 are grants.
  # 06 is "other_financial_assistance" — mixing groups causes a 422.
  r = USAspending.awards.search(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[02 03 04 05]
    },
    limit: 3
  )
  raise 'No grant results' if r.results.empty?

  puts "\n    → #{r.results.size} grants, first: #{r.results.first['Recipient Name']}"
  r
end

results << test('Spending over time (by quarter)') do
  r = USAspending.awards.spending_over_time(
    group: 'quarter',
    filters: {
      'time_period' => [{ 'start_date' => '2023-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    }
  )
  raise 'No time series data' if r.results.empty?

  puts "\n    → #{r.results.size} data points"
  r
end

# ─── 4. Recipient data (who's getting the money) ───
puts "\n▸ Recipients"

results << test('Recipient search (Lockheed)') do
  r = USAspending.recipient.search('Lockheed', award_type: 'contracts', limit: 5)
  raise 'No recipients found' if r.results.empty?

  first = r.results.first
  puts "\n    → #{r.results.size} matches, first: #{first['name']} (#{first['id']})"
  r
end

results << test('All states summary') do
  r = USAspending.recipient.states
  states = r.results
  raise 'No states' if states.empty?

  puts "\n    → #{states.size} states/territories"
  r
end

results << test('State detail (Virginia = 51)') do
  r = USAspending.recipient.state('51', year: 'latest')
  puts "\n    → #{r.raw['name']}: $#{(r.raw['total_amount'].to_f / 1e9).round(1)}B total"
  r
end

# ─── 5. Geographic spending (ThePublicTab map feature) ───
puts "\n▸ Geographic Spending"

results << test('Spending by geography (state level)') do
  r = USAspending.search.spending_by_geography(
    scope: 'place_of_performance',
    geo_layer: 'state',
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    }
  )
  raise 'No geo results' if r.results.empty?

  puts "\n    → #{r.results.size} states with spending data"
  r
end

results << test('Spending by geography (county level, Virginia)') do
  # County drill-down needs place_of_performance_locations filter, not geo_layer_filters
  r = USAspending.search.spending_by_geography(
    scope: 'place_of_performance',
    geo_layer: 'county',
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D],
      'place_of_performance_locations' => [{ 'country' => 'USA', 'state' => 'VA' }]
    }
  )
  raise 'No county results' if r.results.empty?

  puts "\n    → #{r.results.size} Virginia counties with spending data"
  r
end

# ─── 6. Category breakdowns ───
puts "\n▸ Category Breakdowns"

results << test('Spending by NAICS') do
  r = USAspending.search.spending_by_naics(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 5
  )
  raise 'No NAICS results' if r.results.empty?

  puts "\n    → Top NAICS: #{r.results.first['name']} ($#{(r.results.first['amount'].to_f / 1e9).round(1)}B)"
  r
end

results << test('Spending by awarding agency') do
  r = USAspending.search.spending_by_awarding_agency(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 5
  )
  raise 'No agency results' if r.results.empty?

  puts "\n    → Top agency: #{r.results.first['name']}"
  r
end

# ─── 7. Spending Explorer (drill-down) ───
puts "\n▸ Spending Explorer"

results << test('Explorer: budget function drill-down') do
  r = USAspending.spending_explorer.explore(type: 'budget_function', filters: { fy: '2024', quarter: '4' })
  raise 'No explorer results' if r.results.empty?

  puts "\n    → #{r.results.size} budget functions, top: #{r.results.first['name']}"
  r
end

# ─── 8. Autocomplete ───
puts "\n▸ Autocomplete"

results << test('Autocomplete awarding agency') do
  r = USAspending.autocomplete.awarding_agency('defense')
  raise 'No autocomplete results' if r.results.empty?

  puts "\n    → #{r.results.size} matches for 'defense'"
  r
end

results << test('Autocomplete recipient') do
  r = USAspending.autocomplete.recipient('boeing')
  raise 'No autocomplete results' if r.results.empty?

  puts "\n    → #{r.results.size} matches for 'boeing'"
  r
end

# ─── 9. Edge cases ───
puts "\n▸ Edge Cases"

results << test('Empty search (expect 422 — award_type_codes required)') do
  r = USAspending.awards.search(filters: {}, limit: 1)
  puts "\n    → Unexpectedly got results (status #{r.status})"
  r
rescue USAspending::UnprocessableEntityError => e
  puts "\n    → Correctly raised UnprocessableEntityError (#{e.status})"
  puts "    → Message: #{e.body['detail']}"
  :expected_error
end

results << test('Award find with bad ID (expect 404 or empty)') do
  r = USAspending.awards.find('DEFINITELY_NOT_A_REAL_AWARD_ID_12345')
  puts "\n    → Got response with status #{r.status} (API didn't 404)"
  r
rescue USAspending::NotFoundError => e
  puts "\n    → Correctly raised NotFoundError (#{e.status})"
  :not_found
rescue USAspending::UnprocessableEntityError => e
  puts "\n    → Raised UnprocessableEntityError (#{e.status})"
  :unprocessable
end

results << test('Pagination - page 2') do
  r = USAspending.awards.search(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 2,
    page: 2
  )
  raise 'Page 2 returned no results' if r.results.empty?

  puts "\n    → Page 2: #{r.results.size} results"
  r
end

results << test('Response shape: raw hash access') do
  r = USAspending.agency.overview('020', fiscal_year: 2024)
  puts "\n    → r.raw class: #{r.raw.class}"
  puts "    → r['agency_name']: #{r['agency_name']}"
  puts "    → r.to_h keys: #{r.to_h.keys.first(5).join(', ')}..."
  raise 'raw is not a Hash' unless r.raw.is_a?(Hash)
  raise '[] accessor broken' unless r['agency_name'] || r['name']

  r
end

# ─── Summary ───
puts "\n═══════════════════════════════════════════════════"
passed = results.count { |_, s, _| s == :pass }
failed = results.count { |_, s, _| s == :fail }
puts " Results: #{passed} passed, #{failed} failed (#{results.size} total)"
puts '═══════════════════════════════════════════════════'

if failed.positive?
  puts "\n#{FAIL} Failures:"
  results.select { |_, s, _| s == :fail }.each do |name, _, err|
    puts "  - #{name}: #{err.class} — #{err.message}"
  end
end

puts ''
