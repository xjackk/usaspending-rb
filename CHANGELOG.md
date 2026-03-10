# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2025-03-09

### Added
- **21 resource classes** covering ~120 USAspending.gov v2 API endpoints
- **Awards**: search, detail, accounts, funding, counts, and cursor-paginated `search_all`
- **Agency**: overview, budgets, sub-agencies, federal accounts, object classes, program activities, and TAS breakdowns (20 endpoints)
- **Search**: spending by award, geography, category (15 category methods via metaprogramming), transaction, time series, and counts
- **Spending**: validated geographic and categorical breakdowns with `for_district` convenience method
- **Recipient**: search, profiles, child entities, state-level data
- **Autocomplete**: agencies, recipients, locations, NAICS, PSC, CFDA, glossary, city, and TAS components (19 endpoints)
- **References**: CFDA/assistance listings, NAICS, PSC trees, TAS trees, DEF codes, glossary, data dictionary, submission periods
- **Disaster**: COVID/IIJA emergency fund spending — overview, agency/recipient/CFDA/federal account breakdowns, loans, geography
- **Federal Accounts**: list, detail, snapshots, program activities, object classes
- **Downloads**: award/transaction/account CSV generation, status polling, bulk downloads, monthly file listings
- **IDV**: indefinite delivery vehicle awards, activity, funding, amounts
- **Subawards & Transactions**: paginated listings for prime awards
- **Spending Explorer**: drill-down visualization data
- **Reporting**: agency submission history, discrepancies, unlinked awards
- **Financial**: balances by agency, spending by object class, federal obligations, budget functions
- **Award Spending**: recipient breakdowns by fiscal year and agency
- Configurable timeouts, retries, and exponential backoff on 429/5xx
- Response wrapper with `Enumerable`, pagination helpers, `inspect`, `to_json`, `success?`
- Error hierarchy: `HttpError` base with `BadRequestError`, `NotFoundError`, `UnprocessableEntityError`, `RateLimitError`, `ServerError`, `ConnectionError`
- Per-instance client support (`USAspending::Client.new(config)`) with memoized resource accessors
- User-Agent header (`usaspending-rb/VERSION`)
- YARD documentation with `@param`, `@return`, `@raise`, `@example` tags
- RSpec test suite (181 specs, 91%+ coverage)
- SimpleCov with 85% minimum coverage threshold
- RuboCop + rubocop-rspec (0 offenses)
- VCR + WebMock for HTTP fixture recording
- Rakefile with `spec`, `rubocop`, and `yard` tasks
