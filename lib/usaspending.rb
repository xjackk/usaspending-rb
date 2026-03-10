# frozen_string_literal: true

require 'usaspending/version'
require 'usaspending/configuration'
require 'usaspending/error'
require 'usaspending/response'
require 'usaspending/client'
require 'usaspending/resources/base'
require 'usaspending/resources/awards'
require 'usaspending/resources/agency'
require 'usaspending/resources/spending'
require 'usaspending/resources/recipient'
require 'usaspending/resources/autocomplete'
require 'usaspending/resources/references'
require 'usaspending/resources/disaster'
require 'usaspending/resources/search'
require 'usaspending/resources/federal_accounts'
require 'usaspending/resources/download'
require 'usaspending/resources/bulk_download'
require 'usaspending/resources/idv'
require 'usaspending/resources/subawards'
require 'usaspending/resources/transactions'
require 'usaspending/resources/spending_explorer'
require 'usaspending/resources/reporting'
require 'usaspending/resources/federal_obligations'
require 'usaspending/resources/financial_balances'
require 'usaspending/resources/financial_spending'
require 'usaspending/resources/budget_functions'
require 'usaspending/resources/award_spending'

# Ruby client for the USAspending.gov v2 REST API.
#
# @example Basic usage
#   response = USAspending.awards.search(
#     filters: { award_type_codes: %w[A B C D] },
#     limit: 25
#   )
#   response.results.each { |award| puts award["Recipient Name"] }
#
# @example Custom configuration
#   USAspending.configure do |config|
#     config.timeout = 60
#     config.retries = 5
#     config.logger  = Logger.new($stdout)
#   end
#
# @see https://api.usaspending.gov USAspending API documentation
module USAspending
  class << self
    # Returns the current configuration.
    # @return [Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Yields the configuration object for modification.
    # @yield [Configuration] the configuration object
    # @return [void]
    #
    # @example
    #   USAspending.configure do |config|
    #     config.timeout = 60
    #     config.logger  = Logger.new($stdout)
    #   end
    def configure
      yield(configuration)
    end

    # Resets configuration and client to defaults.
    # @return [void]
    def reset!
      @configuration = Configuration.new
      @client = nil
    end

    # Returns the shared HTTP client instance.
    # @return [Client]
    def client
      @client ||= Client.new(configuration)
    end

    # @!group Resource Accessors

    # Award search, detail, funding, and counts.
    # @return [Resources::Awards]
    def awards
      Resources::Awards.new(client)
    end

    # Agency overview, budgets, sub-agencies, and account breakdowns.
    # @return [Resources::Agency]
    def agency
      Resources::Agency.new(client)
    end

    # Geographic and categorical spending breakdowns.
    # @return [Resources::Spending]
    def spending
      Resources::Spending.new(client)
    end

    # Recipient profiles, search, and state-level data.
    # @return [Resources::Recipient]
    def recipient
      Resources::Recipient.new(client)
    end

    # Autocomplete for agencies, recipients, locations, NAICS, PSC, CFDA, and TAS.
    # @return [Resources::Autocomplete]
    def autocomplete
      Resources::Autocomplete.new(client)
    end

    # Reference data: CFDA, NAICS, PSC, DEF codes, glossary, and filter trees.
    # @return [Resources::References]
    def references
      Resources::References.new(client)
    end

    # Disaster and emergency fund spending (COVID, IIJA, etc.).
    # @return [Resources::Disaster]
    def disaster
      Resources::Disaster.new(client)
    end

    # Advanced search: spending by award, geography, category, transaction, and time.
    # @return [Resources::Search]
    def search
      Resources::Search.new(client)
    end

    # Federal account details, snapshots, and program activities.
    # @return [Resources::FederalAccounts]
    def federal_accounts
      Resources::FederalAccounts.new(client)
    end

    # Generate and check status of CSV/TSV file downloads.
    # @return [Resources::Download]
    def download
      Resources::Download.new(client)
    end

    # Bulk download of award data and monthly file listings.
    # @return [Resources::BulkDownload]
    def bulk_download
      Resources::BulkDownload.new(client)
    end

    # Indefinite Delivery Vehicle (IDV) awards, activity, and funding.
    # @return [Resources::Idv]
    def idv
      Resources::Idv.new(client)
    end

    # Subaward listings for prime awards.
    # @return [Resources::Subawards]
    def subawards
      Resources::Subawards.new(client)
    end

    # Transaction listings for awards.
    # @return [Resources::Transactions]
    def transactions
      Resources::Transactions.new(client)
    end

    # Spending Explorer drill-down visualization data.
    # @return [Resources::SpendingExplorer]
    def spending_explorer
      Resources::SpendingExplorer.new(client)
    end

    # Agency reporting data: submission history, discrepancies, and unlinked awards.
    # @return [Resources::Reporting]
    def reporting
      Resources::Reporting.new(client)
    end

    # Federal obligation listings by agency and fiscal year.
    # @return [Resources::FederalObligations]
    def federal_obligations
      Resources::FederalObligations.new(client)
    end

    # Financial balance data by agency.
    # @return [Resources::FinancialBalances]
    def financial_balances
      Resources::FinancialBalances.new(client)
    end

    # Financial spending by object class.
    # @return [Resources::FinancialSpending]
    def financial_spending
      Resources::FinancialSpending.new(client)
    end

    # Budget function and subfunction listings.
    # @return [Resources::BudgetFunctions]
    def budget_functions
      Resources::BudgetFunctions.new(client)
    end

    # Award spending by recipient for a fiscal year and agency.
    # @return [Resources::AwardSpending]
    def award_spending
      Resources::AwardSpending.new(client)
    end

    # @!endgroup
  end
end
