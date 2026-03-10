# frozen_string_literal: true

module USAspending
  module Resources
    class FinancialSpending < Base
      # Returns financial spending data by major object class for latest quarter.
      #
      # @param fiscal_year [Integer]
      # @param funding_agency_id [Integer]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def major_object_class(fiscal_year:, funding_agency_id:, limit: 10, page: 1)
        get('financial_spending/major_object_class/', {
              fiscal_year: fiscal_year, funding_agency_id: funding_agency_id,
              limit: limit, page: page
            })
      end

      # Returns financial spending data by object class for latest quarter.
      #
      # @param fiscal_year [Integer]
      # @param funding_agency_id [Integer]
      # @param major_object_class_code [String]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def object_class(fiscal_year:, funding_agency_id:, major_object_class_code: nil, limit: 10, page: 1)
        params = {
          fiscal_year: fiscal_year, funding_agency_id: funding_agency_id,
          limit: limit, page: page
        }
        params[:major_object_class_code] = major_object_class_code if major_object_class_code
        get('financial_spending/object_class/', params)
      end
    end
  end
end
