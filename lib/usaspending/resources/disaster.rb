# frozen_string_literal: true

module USAspending
  module Resources
    class Disaster < Base
      # ------------------------------------------------------------------ #
      # 1. GET /api/v2/disaster/overview/
      # ------------------------------------------------------------------ #

      # High-level overview of disaster/emergency fund spending.
      #
      # @param def_codes [Array<String>] filter to specific DEFC codes
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Fetch disaster spending overview
      #   client = USAspending::Client.new
      #   response = client.disaster.overview(def_codes: ["L", "M", "N", "O", "P"])
      #   response.data["funding"] #=> Array of funding totals by DEFC
      def overview(def_codes: nil)
        params = {}
        params[:def_codes] = def_codes if def_codes
        get('disaster/overview/', params)
      end

      # ------------------------------------------------------------------ #
      # 2-4. Agency endpoints
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agency_count(def_codes:)
        post('disaster/agency/count/', filter_body(def_codes))
      end

      # @param def_codes [Array<String>]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agency_loans(def_codes:, limit: 10, page: 1)
        post('disaster/agency/loans/', paginated_body(def_codes, limit, page))
      end

      # @param def_codes [Array<String>]
      # @param spending_type [String]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agency_spending(def_codes:, spending_type: 'total', limit: 10, page: 1)
        post('disaster/agency/spending/',
             paginated_body(def_codes, limit, page, spending_type: spending_type))
      end

      # ------------------------------------------------------------------ #
      # 5-6. Award endpoints
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def award_amount(def_codes:)
        post('disaster/award/amount/', filter_body(def_codes))
      end

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def award_count(def_codes:)
        post('disaster/award/count/', filter_body(def_codes))
      end

      # ------------------------------------------------------------------ #
      # 7-9. CFDA endpoints
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def cfda_count(def_codes:)
        post('disaster/cfda/count/', filter_body(def_codes))
      end

      # @param def_codes [Array<String>]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def cfda_loans(def_codes:, limit: 10, page: 1)
        post('disaster/cfda/loans/', paginated_body(def_codes, limit, page))
      end

      # @param def_codes [Array<String>]
      # @param spending_type [String]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def cfda_spending(def_codes:, spending_type: 'total', limit: 10, page: 1)
        post('disaster/cfda/spending/',
             paginated_body(def_codes, limit, page, spending_type: spending_type))
      end

      # ------------------------------------------------------------------ #
      # 10. DEF code count
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def def_code_count(def_codes:)
        post('disaster/def_code/count/', filter_body(def_codes))
      end

      # ------------------------------------------------------------------ #
      # 11-13. Federal account endpoints
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def federal_account_count(def_codes:)
        post('disaster/federal_account/count/', filter_body(def_codes))
      end

      # @param def_codes [Array<String>]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def federal_account_loans(def_codes:, limit: 10, page: 1)
        post('disaster/federal_account/loans/', paginated_body(def_codes, limit, page))
      end

      # @param def_codes [Array<String>]
      # @param spending_type [String]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def federal_account_spending(def_codes:, spending_type: 'total', limit: 10, page: 1)
        post('disaster/federal_account/spending/',
             paginated_body(def_codes, limit, page, spending_type: spending_type))
      end

      # ------------------------------------------------------------------ #
      # 14-16. Object class endpoints
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def object_class_count(def_codes:)
        post('disaster/object_class/count/', filter_body(def_codes))
      end

      # @param def_codes [Array<String>]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def object_class_loans(def_codes:, limit: 10, page: 1)
        post('disaster/object_class/loans/', paginated_body(def_codes, limit, page))
      end

      # @param def_codes [Array<String>]
      # @param spending_type [String]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def object_class_spending(def_codes:, spending_type: 'total', limit: 10, page: 1)
        post('disaster/object_class/spending/',
             paginated_body(def_codes, limit, page, spending_type: spending_type))
      end

      # ------------------------------------------------------------------ #
      # 17-19. Recipient endpoints
      # ------------------------------------------------------------------ #

      # @param def_codes [Array<String>]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def recipient_count(def_codes:)
        post('disaster/recipient/count/', filter_body(def_codes))
      end

      # @param def_codes [Array<String>]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def recipient_loans(def_codes:, limit: 10, page: 1)
        post('disaster/recipient/loans/', paginated_body(def_codes, limit, page))
      end

      # @param def_codes [Array<String>]
      # @param spending_type [String]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def recipient_spending(def_codes:, spending_type: 'total', limit: 10, page: 1)
        post('disaster/recipient/spending/',
             paginated_body(def_codes, limit, page, spending_type: spending_type))
      end

      # ------------------------------------------------------------------ #
      # 20. Geographic spending
      # ------------------------------------------------------------------ #

      # Spending breakdown by geographic area for disaster codes.
      #
      # @param def_codes      [Array<String>]
      # @param geo_layer      [String] "state", "county", or "congressional_district"
      # @param spending_type  [String]
      # @param scope          [String] "place_of_performance" or "recipient_location"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_geography(def_codes:, geo_layer: 'state', spending_type: 'obligation',
                                scope: 'place_of_performance')
        body = {
          filter: { def_codes: def_codes },
          geo_layer: geo_layer,
          scope: scope,
          spending_type: spending_type
        }
        post('disaster/spending_by_geography/', body)
      end

      # Convenience alias retained for backward compatibility.
      alias by_geography spending_by_geography

      private

      # Build a minimal body with only the filter object.
      def filter_body(def_codes)
        { filter: { def_codes: def_codes } }
      end

      # Build a paginated body, optionally including spending_type.
      def paginated_body(def_codes, limit, page, spending_type: 'total')
        {
          filter: { def_codes: def_codes },
          spending_type: spending_type,
          limit: limit,
          page: page
        }
      end
    end
  end
end
