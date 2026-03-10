# USAspending

A Ruby client for the [USAspending.gov](https://api.usaspending.gov) REST API v2. Access federal award data, agency spending, geographic breakdowns, recipient profiles, and more.

No API key required. The USAspending.gov API is fully public.

## Installation

Add to your Gemfile:

```ruby
gem 'usaspending'
```

Then `bundle install`, or install directly:

```bash
gem install usaspending
```

## Quick Start

```ruby
require 'usaspending'

# Search for contracts
response = USAspending.awards.search(
  filters: { award_type_codes: %w[A B C D] },
  limit: 10
)
response.each { |award| puts award['Recipient Name'] }
```

## Usage

### Award Search

```ruby
response = USAspending.awards.search(
  filters: {
    award_type_codes: %w[A B C D],
    place_of_performance_locations: [
      { country: 'USA', state: 'VA', congressional_district: '08' }
    ]
  },
  fields: ['Award ID', 'Recipient Name', 'Award Amount'],
  sort: 'Award Amount',
  limit: 25
)

response.results       # => [{ "Award ID" => "...", ... }, ...]
response.size          # => 25
response.total_count   # => 1234
response.next_page?    # => true
```

### Paginate All Results

Uses cursor pagination for reliability with large result sets:

```ruby
USAspending.awards.search_all(
  filters: { award_type_codes: %w[A B C D] },
  limit: 100
) do |page|
  page.each { |award| save_to_db(award) }
end
```

### Award Detail

```ruby
award = USAspending.awards.find('CONT_AWD_N0018923C0001_9700_-NONE-_-NONE-')
award['description']
award['total_obligation']

# Related data
USAspending.awards.accounts(award_id: 'CONT_AWD_...')
USAspending.awards.funding(award_id: 'CONT_AWD_...')
USAspending.awards.transaction_count('CONT_AWD_...')
```

### Geographic Spending

```ruby
# State-level breakdown
response = USAspending.spending.by_geography(
  scope: 'place_of_performance',
  geo_layer: 'state',
  filters: { fiscal_years: [2025] }
)

# Congressional district convenience method
response = USAspending.spending.for_district(
  state_abbr: 'VA',
  district: '08',
  fiscal_years: [2025]
)
```

### Category Breakdown

```ruby
# By NAICS industry code
USAspending.spending.by_category(
  category: 'naics',
  filters: { fiscal_years: [2025] },
  limit: 25
)

# Or use Search directly for any of the 15 categories
USAspending.search.spending_by_awarding_agency(filters: { fiscal_years: [2025] })
USAspending.search.spending_by_recipient(filters: { fiscal_years: [2025] })
USAspending.search.spending_by_cfda(filters: { fiscal_years: [2025] })
USAspending.search.spending_by_naics(filters: { fiscal_years: [2025] })
USAspending.search.spending_by_psc(filters: { fiscal_years: [2025] })
# ... and 10 more category methods
```

### Agency Data

```ruby
# List all top-tier agencies
agencies = USAspending.agency.list

# Agency overview (e.g. Treasury = "020")
treasury = USAspending.agency.overview('020', fiscal_year: 2025)

# Drill down
USAspending.agency.sub_agencies('020', fiscal_year: 2025)
USAspending.agency.federal_accounts('020', fiscal_year: 2025)
USAspending.agency.budget_function('020', fiscal_year: 2025)
USAspending.agency.obligations_by_award_category('020', fiscal_year: 2025)
USAspending.agency.budgetary_resources('020')
```

### Recipient Data

```ruby
# Search recipients
results = USAspending.recipient.search('Lockheed Martin')

# Recipient profile
profile = USAspending.recipient.find('abc123-hash-value')

# State-level data
states = USAspending.recipient.states
virginia = USAspending.recipient.state('51') # FIPS code
```

### Autocomplete

```ruby
USAspending.autocomplete.location('22201', geo_layer: 'zip_code')
USAspending.autocomplete.naics('541')
USAspending.autocomplete.recipient('Lockheed')
USAspending.autocomplete.awarding_agency('Treasury')
USAspending.autocomplete.city('Arlington', state_code: 'VA')
USAspending.autocomplete.psc('R425')
```

### Reference Data

```ruby
USAspending.references.toptier_agencies
USAspending.references.assistance_listings  # CFDA programs
USAspending.references.def_codes            # Disaster emergency fund codes
USAspending.references.naics(depth: 2)      # NAICS industry codes
USAspending.references.psc_tree             # Product service codes
USAspending.references.data_dictionary
USAspending.references.glossary
USAspending.references.submission_periods
```

### Disaster / Emergency Fund Spending

```ruby
# COVID spending overview
USAspending.disaster.overview(def_codes: %w[L M N])

# Drill down by entity
USAspending.disaster.agency_spending(def_codes: %w[L M])
USAspending.disaster.recipient_spending(def_codes: %w[L])
USAspending.disaster.cfda_spending(def_codes: %w[L])

# Geographic breakdown
USAspending.disaster.spending_by_geography(def_codes: %w[L], geo_layer: 'state')
```

### Spending Explorer

```ruby
USAspending.spending_explorer.explore(
  type: 'budget_function',
  filters: { fy: '2025', quarter: '1' }
)
```

### Downloads

```ruby
# Generate a CSV download
response = USAspending.download.awards(
  filters: { award_type_codes: %w[A], fiscal_years: [2025] }
)
file_name = response['file_name']

# Check status
USAspending.download.status(file_name)

# Bulk downloads
USAspending.bulk_download.awards(filters: { fiscal_years: [2025] })
```

### Federal Accounts

```ruby
USAspending.federal_accounts.list
USAspending.federal_accounts.find('020-0001') # by account code
USAspending.federal_accounts.fiscal_year_snapshot(1234) # by numeric ID
```

### Additional Resources

```ruby
# Transactions for an award
USAspending.transactions.list(award_id: 'CONT_AWD_...')

# Subawards
USAspending.subawards.list(award_id: 'CONT_AWD_...')

# IDV (Indefinite Delivery Vehicles)
USAspending.idv.amounts('IDV_AWD_...')
USAspending.idv.awards(award_id: 'IDV_AWD_...')

# Reporting
USAspending.reporting.agencies_overview(fiscal_year: 2025, fiscal_period: 6)

# Financial data
USAspending.financial_balances.agencies(funding_agency_identifier: '020', fiscal_year: 2025)
USAspending.budget_functions.list
```

## Configuration

```ruby
USAspending.configure do |config|
  config.timeout = 60                      # Request timeout in seconds (default: 30)
  config.retries = 5                       # Max retries on 429/5xx (default: 3)
  config.logger  = Logger.new($stdout)     # Optional request logging
end
```

### Rails Initializer

```ruby
# config/initializers/usaspending.rb
USAspending.configure do |config|
  config.timeout = 30
  config.retries = 3
  config.logger  = Rails.logger if Rails.env.development?
end
```

### Per-Instance Client

For different configurations in the same process:

```ruby
client = USAspending::Client.new(custom_config)
client.awards.search(filters: { ... })
client.agency.overview('020')
```

## Response Object

All API calls return a `USAspending::Response`:

```ruby
response = USAspending.awards.search(filters: { ... })

response.results             # Array of result hashes
response.each { |r| ... }   # Enumerable — supports map, select, first, etc.
response.size                # Results on this page
response.empty?              # No results?
response.total_count         # Total matching records (not just this page)
response.next_page?          # More pages available?
response.last_record_unique_id  # Cursor for next page
response.success?            # HTTP 2xx?

response['key']              # Direct hash access
response.dig('nested', 'key')
response.raw                 # Raw parsed JSON body
response.to_h                # Always returns a Hash
response.to_json             # JSON string
```

## Error Handling

```ruby
begin
  USAspending.awards.find('INVALID')
rescue USAspending::BadRequestError => e
  puts "Bad request: #{e.status} — #{e.body}"
rescue USAspending::NotFoundError => e
  puts "Not found: #{e.status}"
rescue USAspending::UnprocessableEntityError => e
  puts "Invalid filters: #{e.body}"
rescue USAspending::RateLimitError
  puts 'Rate limited — retries exhausted'
rescue USAspending::ServerError => e
  puts "Server error: #{e.status}"
rescue USAspending::ConnectionError => e
  puts "Network issue: #{e.message}"
end
```

Error hierarchy:

```
USAspending::Error
├── HttpError
│   ├── ClientError
│   │   ├── BadRequestError      (400)
│   │   ├── NotFoundError        (404)
│   │   ├── UnprocessableEntityError (422)
│   │   └── RateLimitError       (429)
│   └── ServerError              (500+)
└── ConnectionError              (timeouts, DNS, refused)
```

All `HttpError` subclasses expose `.status` and `.body`.

## Development

```bash
git clone https://github.com/thepublictab/usaspending-rb.git
cd usaspending-rb
bundle install

bundle exec rspec       # Run tests
bundle exec rubocop     # Lint
bundle exec yard        # Generate docs
bundle exec rake        # Default: runs rspec
```

## Requirements

- Ruby >= 3.1
- Faraday ~> 2.0

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
