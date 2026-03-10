#!/usr/bin/env ruby
# frozen_string_literal: true

# Deep smoke test — round 2: untested resources, edge cases, data quality
# Run: bundle exec ruby examples/deep_smoke_test.rb

require 'bundler/setup'
require 'usaspending'
require 'logger'

USAspending.configure do |config|
  config.timeout = 90
  config.logger  = Logger.new($stdout, level: Logger::WARN)
end

PASS = "\e[32m✓\e[0m"
FAIL = "\e[31m✗\e[0m"

results = []

def test(name)
  print "  #{name}... "
  result = yield
  puts(PASS)
  [name, :pass, result]
rescue StandardError => e
  puts "#{FAIL} #{e.class}: #{e.message[0..150]}"
  [name, :fail, e]
end

puts "\n═══════════════════════════════════════════════════"
puts ' Deep Smoke Test — Round 2'
puts "═══════════════════════════════════════════════════\n"

# ═══════════════════════════════════════════════════
# 1. DISASTER ENDPOINTS (COVID tracking for ThePublicTab)
# ═══════════════════════════════════════════════════
puts "\n▸ Disaster / Emergency Fund Spending"

covid_codes = %w[L M N O P]

results << test('disaster.overview') do
  r = USAspending.disaster.overview
  raise 'Empty response' if r.raw.nil? || r.raw.empty?

  puts "\n    → Keys: #{r.raw.keys.join(', ')}"
  r
end

results << test('disaster.agency_count(COVID)') do
  r = USAspending.disaster.agency_count(def_codes: covid_codes)
  puts "\n    → Raw: #{r.raw.inspect[0..100]}"
  r
end

results << test('disaster.agency_spending(COVID)') do
  r = USAspending.disaster.agency_spending(def_codes: covid_codes, limit: 3)
  puts "\n    → #{r.results.size} agencies, first: #{r.results.first&.dig('description')}"
  r
end

results << test('disaster.award_amount(COVID)') do
  r = USAspending.disaster.award_amount(def_codes: covid_codes)
  puts "\n    → Raw keys: #{r.raw.keys}" if r.raw.is_a?(Hash)
  r
end

results << test('disaster.recipient_spending(COVID)') do
  r = USAspending.disaster.recipient_spending(def_codes: covid_codes, limit: 3)
  puts "\n    → #{r.results.size} recipients"
  r
end

results << test('disaster.spending_by_geography(COVID, state)') do
  r = USAspending.disaster.spending_by_geography(def_codes: covid_codes, geo_layer: 'state')
  puts "\n    → #{r.results.size} states with disaster spending"
  r
end

# ═══════════════════════════════════════════════════
# 2. FEDERAL ACCOUNTS
# ═══════════════════════════════════════════════════
puts "\n▸ Federal Accounts"

results << test('federal_accounts.list') do
  r = USAspending.federal_accounts.list(limit: 3)
  raise 'No accounts' if r.results.empty?

  first = r.results.first
  puts "\n    → #{first['account_title']} (#{first['agency_identifier']}-#{first['main_account_code']})"
  r
end

results << test("federal_accounts.find('020-0101')") do
  r = USAspending.federal_accounts.find('020-0101')
  puts "\n    → #{r.raw['agency_identifier']}: #{r.raw['account_title']}"
  r
end

results << test('federal_accounts.fiscal_year_snapshot (by numeric id)') do
  acct = USAspending.federal_accounts.find('020-0101')
  r = USAspending.federal_accounts.fiscal_year_snapshot(acct.raw['id'])
  puts "\n    → Keys: #{r.raw.keys.join(', ')}" if r.raw.is_a?(Hash)
  puts "\n    → #{r.results.size} snapshot entries" if r.results.any?
  r
end

# ═══════════════════════════════════════════════════
# 3. REPORTING (About the Data — transparency metrics)
# ═══════════════════════════════════════════════════
puts "\n▸ Reporting / About the Data"

results << test('reporting.agencies_overview (FY2024 P6)') do
  r = USAspending.reporting.agencies_overview(fiscal_year: 2024, fiscal_period: 6, limit: 3)
  raise 'No results' if r.results.empty?

  first = r.results.first
  puts "\n    → #{first['agency_name']}: #{first['recent_publication_date']}"
  r
end

results << test('reporting.agency_overview (Treasury 020)') do
  r = USAspending.reporting.agency_overview('020', limit: 3)
  puts "\n    → #{r.results.size} periods returned"
  r
end

results << test('reporting.submission_history (Treasury 020, FY2024 P6)') do
  r = USAspending.reporting.submission_history('020', fiscal_year: 2024, fiscal_period: 6)
  puts "\n    → Raw keys: #{r.raw.keys}" if r.raw.is_a?(Hash)
  puts "\n    → #{r.results.size} history entries" if r.results.any?
  r
end

# ═══════════════════════════════════════════════════
# 4. TRANSACTIONS & SUBAWARDS
# ═══════════════════════════════════════════════════
puts "\n▸ Transactions & Subawards"

results << test('transactions.list') do
  r = USAspending.transactions.list(
    award_id: 'CONT_AWD_GS23F0170L_4730_GS00Q14OADS347_4730',
    limit: 3
  )
  puts "\n    → #{r.results.size} transactions"
  r
end

results << test('subawards.list') do
  r = USAspending.subawards.list(
    award_id: 'CONT_AWD_GS23F0170L_4730_GS00Q14OADS347_4730',
    limit: 3
  )
  puts "\n    → #{r.results.size} subawards"
  r
end

# ═══════════════════════════════════════════════════
# 5. REFERENCES (deep — data dictionary, NAICS, PSC trees)
# ═══════════════════════════════════════════════════
puts "\n▸ References (Deep)"

results << test('references.data_dictionary') do
  r = USAspending.references.data_dictionary
  puts "\n    → Raw keys: #{r.raw.keys}" if r.raw.is_a?(Hash)
  puts "\n    → #{r.results.size} entries" if r.results.any?
  r
end

results << test("references.naics_code('541')") do
  r = USAspending.references.naics_code('541')
  puts "\n    → Keys: #{r.raw.keys}" if r.raw.is_a?(Hash)
  r
end

results << test('references.filter (keyword)') do
  r = USAspending.references.filter(keyword: 'defense')
  puts "\n    → Raw keys: #{r.raw.keys}" if r.raw.is_a?(Hash)
  r
end

results << test('references.total_budgetary_resources') do
  r = USAspending.references.total_budgetary_resources
  puts "\n    → #{r.results.size} results"
  r
end

# ═══════════════════════════════════════════════════
# 6. BULK DOWNLOAD
# ═══════════════════════════════════════════════════
puts "\n▸ Bulk Download"

results << test('bulk_download.list_agencies') do
  r = USAspending.bulk_download.list_agencies
  puts "\n    → Raw keys: #{r.raw.keys}" if r.raw.is_a?(Hash)
  r
end

results << test('bulk_download.status (fake file)') do
  r = USAspending.bulk_download.status('nonexistent_file.zip')
  puts "\n    → status: #{r.raw['status']}"
  r
rescue USAspending::ClientError, USAspending::ServerError => e
  puts "\n    → Expected error: #{e.class} (#{e.status})"
  :expected_error
end

# ═══════════════════════════════════════════════════
# 7. DOWNLOAD (async file generation)
# ═══════════════════════════════════════════════════
puts "\n▸ Download"

results << test('download.count (contracts FY2024)') do
  r = USAspending.download.count(
    filters: {
      'time_period' => [{ 'start_date' => '2024-10-01', 'end_date' => '2024-12-31' }],
      'award_type_codes' => %w[A B C D]
    }
  )
  puts "\n    → Raw: #{r.raw.inspect[0..100]}"
  r
end

# ═══════════════════════════════════════════════════
# 8. AUTOCOMPLETE EDGE CASES
# ═══════════════════════════════════════════════════
puts "\n▸ Autocomplete Edge Cases"

results << test("autocomplete.naics ('5411')") do
  r = USAspending.autocomplete.naics('5411')
  raise 'No NAICS results' if r.results.empty?

  puts "\n    → #{r.results.size} matches, first: #{r.results.first.inspect[0..80]}"
  r
end

results << test("autocomplete.psc ('R425')") do
  r = USAspending.autocomplete.psc('R425')
  puts "\n    → #{r.results.size} matches"
  r
end

results << test("autocomplete.city ('Arlington')") do
  r = USAspending.autocomplete.city('Arlington')
  raise 'No city results' if r.results.empty?

  puts "\n    → #{r.results.size} matches"
  r
end

results << test("autocomplete.location ('22201', zip_code)") do
  r = USAspending.autocomplete.location('22201', geo_layer: 'zip_code')
  puts "\n    → #{r.results.size} matches"
  r
end

results << test('autocomplete empty search (expect 400)') do
  r = USAspending.autocomplete.awarding_agency('')
  puts "\n    → #{r.results.size} results for empty string"
  r
rescue USAspending::ClientError => e
  puts "\n    → Correctly raised #{e.class} (search_text required)"
  :expected_error
end

# ═══════════════════════════════════════════════════
# 9. SEARCH EDGE CASES & DATA QUALITY
# ═══════════════════════════════════════════════════
puts "\n▸ Search Data Quality for ThePublicTab"

results << test('spending_by_transaction (keyword search)') do
  r = USAspending.search.spending_by_transaction(
    filters: {
      'keywords' => ['renewable energy'],
      'award_type_codes' => %w[A B C D]
    },
    fields: ['Transaction Amount', 'Recipient Name', 'Action Date', 'Award ID'],
    limit: 3
  )
  raise 'No transaction results' if r.results.empty?

  first = r.results.first
  puts "\n    → Fields returned: #{first.keys.join(', ')}"
  r
end

results << test('transaction_spending_summary') do
  r = USAspending.search.transaction_spending_summary(
    filters: {
      'keywords' => ['infrastructure'],
      'award_type_codes' => %w[A B C D]
    }
  )
  puts "\n    → Raw: #{r.raw.inspect[0..200]}"
  r
end

results << test('new_awards_over_time (requires recipient_id)') do
  # This endpoint requires recipient_id in filters
  search = USAspending.recipient.search('Lockheed', award_type: 'contracts', limit: 1)
  recipient_id = search.results.first['id']
  r = USAspending.search.new_awards_over_time(
    group: 'fiscal_year',
    filters: {
      'recipient_id' => recipient_id,
      'award_type_codes' => %w[A B C D]
    }
  )
  raise 'No time series' if r.results.empty?

  puts "\n    → #{r.results.size} fiscal years of Lockheed award data"
  r
end

# ═══════════════════════════════════════════════════
# 10. PAGINATION DEEP-DIVE
# ═══════════════════════════════════════════════════
puts "\n▸ Pagination Deep-Dive"

results << test('search_all iterator (2 pages max)') do
  pages = 0
  total_records = 0
  USAspending.awards.search_all(
    filters: {
      'time_period' => [{ 'start_date' => '2024-06-01', 'end_date' => '2024-06-30' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 5
  ) do |batch|
    pages += 1
    total_records += batch.size
    break if pages >= 2
  end
  puts "\n    → Iterated #{pages} pages, #{total_records} total records"
  raise 'Iterator yielded 0 pages' if pages.zero?

  :ok
end

results << test("Large limit (100) doesn't break") do
  r = USAspending.awards.search(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-01-31' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 100
  )
  puts "\n    → #{r.results.size} results returned for limit=100"
  r
end

results << test('Limit > 100 (should get 422 or clamped)') do
  r = USAspending.awards.search(
    filters: {
      'time_period' => [{ 'start_date' => '2024-01-01', 'end_date' => '2024-01-31' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 500
  )
  puts "\n    → Got #{r.results.size} results (API clamped or accepted)"
  r
rescue USAspending::ClientError, USAspending::UnprocessableEntityError => e
  puts "\n    → Expected: #{e.class} (#{e.status})"
  :expected_error
end

# ═══════════════════════════════════════════════════
# 11. RESPONSE SHAPE EDGE CASES
# ═══════════════════════════════════════════════════
puts "\n▸ Response Shape Edge Cases"

results << test('Scalar response (award_count returns counts hash)') do
  r = USAspending.disaster.award_count(def_codes: covid_codes)
  puts "\n    → raw class: #{r.raw.class}, keys: #{begin
    r.raw.keys
  rescue StandardError
    'N/A'
  end}"
  r
end

results << test('Agency overview (non-paginated, flat hash)') do
  r = USAspending.agency.overview('097', fiscal_year: 2024)
  name = r['name'] || r['agency_name']
  raise 'No name field' unless name

  puts "\n    → #{name}: budget_authority=#{r['budget_authority_amount']}"
  r
end

results << test('References glossary (paginated with page_metadata?)') do
  r = USAspending.references.glossary
  puts "\n    → has_next_page?: #{r.has_next_page?}"
  puts "    → total_count: #{r.total_count}"
  puts "    → #{r.results.size} terms"
  r
end

# ═══════════════════════════════════════════════════
# 12. ThePublicTab-SPECIFIC DATA FLOWS
# ═══════════════════════════════════════════════════
puts "\n▸ ThePublicTab-Specific Flows"

results << test('Flow: Top 10 contractors by award amount (FY2024)') do
  r = USAspending.search.spending_by_recipient(
    filters: {
      'time_period' => [{ 'start_date' => '2023-10-01', 'end_date' => '2024-09-30' }],
      'award_type_codes' => %w[A B C D]
    },
    limit: 10
  )
  raise 'No recipients' if r.results.empty?

  r.results.each_with_index do |rec, i|
    puts "\n    #{i + 1}. #{rec['name']}: $#{(rec['amount'].to_f / 1e9).round(2)}B" if i < 5
  end
  r
end

results << test('Flow: DoD spending by congressional district') do
  r = USAspending.search.spending_by_geography(
    scope: 'recipient_location',
    geo_layer: 'district',
    filters: {
      'time_period' => [{ 'start_date' => '2023-10-01', 'end_date' => '2024-09-30' }],
      'award_type_codes' => %w[A B C D],
      'agencies' => [{ 'type' => 'awarding', 'tier' => 'toptier', 'name' => 'Department of Defense' }]
    }
  )
  raise 'No district results' if r.results.empty?

  top = r.results.max_by { |d| d['aggregated_amount'].to_f }
  puts "\n    → #{r.results.size} districts, top: #{top['display_name']} ($#{(top['aggregated_amount'].to_f / 1e9).round(2)}B)"
  r
end

results << test('Flow: Spending by state for all FY2024 grants') do
  r = USAspending.search.spending_by_geography(
    scope: 'recipient_location',
    geo_layer: 'state',
    filters: {
      'time_period' => [{ 'start_date' => '2023-10-01', 'end_date' => '2024-09-30' }],
      'award_type_codes' => %w[02 03 04 05]
    }
  )
  raise 'No state results' if r.results.empty?

  top = r.results.max_by { |s| s['aggregated_amount'].to_f }
  puts "\n    → #{r.results.size} states, top grants: #{top['display_name']} ($#{(top['aggregated_amount'].to_f / 1e9).round(1)}B)"
  r
end

results << test('Flow: Recipient profile → Lockheed → children') do
  # Search for Lockheed
  search = USAspending.recipient.search('Lockheed Martin', award_type: 'contracts', limit: 1)
  raise 'No Lockheed found' if search.results.empty?

  lm = search.results.first
  puts "\n    → Found: #{lm['name']} (#{lm['id']})"

  # Get profile
  profile = USAspending.recipient.find(lm['id'], year: 'latest')
  puts "    → Total: $#{(profile.raw['total'].to_f / 1e9).round(2)}B"

  # Get UEI/DUNS for children
  uei = profile.raw['uei'] || profile.raw['recipient_id']
  if uei
    children = USAspending.recipient.children(uei, year: 'latest')
    puts "    → #{children.results.size} child entities"
  else
    puts '    → No UEI available for children lookup'
  end
  :ok
end

results << test('Flow: Budget function drill-down → subfunction') do
  # Top level
  top = USAspending.spending_explorer.explore(
    type: 'budget_function',
    filters: { fy: '2024', quarter: '4' }
  )
  raise 'No budget functions' if top.results.empty?

  first_fn = top.results.first
  puts "\n    → Top function: #{first_fn['name']} ($#{(first_fn['amount'].to_f / 1e12).round(2)}T)"

  # Drill into subfunction using the id
  sub = USAspending.spending_explorer.explore(
    type: 'budget_subfunction',
    filters: { fy: '2024', quarter: '4', budget_function: first_fn['code'] || first_fn['id'] }
  )
  puts "    → #{sub.results.size} subfunctions under #{first_fn['name']}"
  :ok
end

# ═══════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════
puts "\n═══════════════════════════════════════════════════"
passed = results.count { |_, s, _| s == :pass }
failed = results.count { |_, s, _| s == :fail }
puts " Results: #{passed} passed, #{failed} failed (#{results.size} total)"
puts '═══════════════════════════════════════════════════'

if failed.positive?
  puts "\n#{FAIL} Failures:"
  results.select { |_, s, _| s == :fail }.each do |name, _, err|
    puts "  - #{name}: #{err.class} — #{err.message[0..200]}"
  end
end

puts ''
