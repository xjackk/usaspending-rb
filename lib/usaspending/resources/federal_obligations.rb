# frozen_string_literal: true

module USAspending
  module Resources
    class FederalObligations < Base
      # Returns paginated list of obligations for the provided agency for the year.
      #
      # @param fiscal_year [Integer]
      # @param funding_agency_id [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list(fiscal_year:, funding_agency_id:, limit: 10, page: 1)
        get('federal_obligations/', {
              fiscal_year: fiscal_year, funding_agency_id: funding_agency_id,
              limit: limit, page: page
            })
      end
    end
  end
end
