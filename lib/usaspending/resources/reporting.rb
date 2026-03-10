# frozen_string_literal: true

module USAspending
  module Resources
    class Reporting < Base
      # Returns About the Data information about all agencies with submissions.
      #
      # @param fiscal_year [Integer]
      # @param fiscal_period [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @param sort [String]
      # @param order [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agencies_overview(fiscal_year:, fiscal_period:, limit: 10, page: 1,
                            sort: 'current_total_budget_authority_amount', order: 'desc')
        get('reporting/agencies/overview/', {
              fiscal_year: fiscal_year, fiscal_period: fiscal_period,
              limit: limit, page: page, sort: sort, order: order
            })
      end

      # Returns submission publication and certification information.
      #
      # @param fiscal_year [Integer]
      # @param fiscal_period [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agencies_publish_dates(fiscal_year:, fiscal_period:, limit: 10, page: 1)
        get('reporting/agencies/publish_dates/', {
              fiscal_year: fiscal_year, fiscal_period: fiscal_period, limit: limit, page: page
            })
      end

      # Returns information about differences in account balances for an agency.
      #
      # @param toptier_code [String]
      # @param fiscal_year [Integer]
      # @param fiscal_period [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def differences(toptier_code, fiscal_year:, fiscal_period:, limit: 10, page: 1)
        get("reporting/agencies/#{toptier_code}/differences/", {
              fiscal_year: fiscal_year, fiscal_period: fiscal_period, limit: limit, page: page
            })
      end

      # Returns TAS discrepancies of the specified agency's submission data.
      #
      # @param toptier_code [String]
      # @param fiscal_year [Integer]
      # @param fiscal_period [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def discrepancies(toptier_code, fiscal_year:, fiscal_period:, limit: 10, page: 1)
        get("reporting/agencies/#{toptier_code}/discrepancies/", {
              fiscal_year: fiscal_year, fiscal_period: fiscal_period, limit: limit, page: page
            })
      end

      # Returns list of submission data for the provided agency.
      #
      # @param toptier_code [String]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agency_overview(toptier_code, limit: 10, page: 1)
        get("reporting/agencies/#{toptier_code}/overview/", { limit: limit, page: page })
      end

      # Returns submission publication and certified dates for the agency/period.
      #
      # @param toptier_code [String]
      # @param fiscal_year [Integer]
      # @param fiscal_period [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def submission_history(toptier_code, fiscal_year:, fiscal_period:)
        get("reporting/agencies/#{toptier_code}/#{fiscal_year}/#{fiscal_period}/submission_history/")
      end

      # Returns counts of linked and unlinked awards for a period.
      #
      # @param toptier_code [String]
      # @param fiscal_year [Integer]
      # @param fiscal_period [Integer]
      # @param type [String] "assistance" or "procurement"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def unlinked_awards(toptier_code, fiscal_year:, fiscal_period:, type:)
        get("reporting/agencies/#{toptier_code}/#{fiscal_year}/#{fiscal_period}/unlinked_awards/#{type}/")
      end
    end
  end
end
