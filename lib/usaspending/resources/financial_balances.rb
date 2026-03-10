# frozen_string_literal: true

module USAspending
  module Resources
    class FinancialBalances < Base
      # Returns financial balances by agency and latest quarter for fiscal year.
      #
      # @param funding_agency_identifier [String]
      # @param fiscal_year [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agencies(funding_agency_identifier:, fiscal_year:)
        get('financial_balances/agencies/', {
              funding_agency_identifier: funding_agency_identifier,
              fiscal_year: fiscal_year
            })
      end
    end
  end
end
