# frozen_string_literal: true

module USAspending
  module Resources
    class AwardSpending < Base
      # Returns all award spending by recipient for a given fiscal year and agency.
      #
      # @param fiscal_year [Integer]
      # @param awarding_agency_id [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def by_recipient(fiscal_year:, awarding_agency_id:, limit: 10, page: 1)
        get('award_spending/recipient/', {
              fiscal_year: fiscal_year, awarding_agency_id: awarding_agency_id,
              limit: limit, page: page
            })
      end
    end
  end
end
