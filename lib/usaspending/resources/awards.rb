# frozen_string_literal: true

require 'cgi'

module USAspending
  module Resources
    class Awards < Base
      # ----------------------------------------------------------------
      # Search convenience methods — delegate to Search resource
      # ----------------------------------------------------------------

      # Search for awards using the full filter DSL.
      # Delegates to {Search#spending_by_award} with sensible field defaults.
      #
      # @param filters [Hash] USAspending filter object (see API docs)
      # @param fields  [Array<String>] specific fields to return (default: core fields)
      # @param sort    [String] field to sort by (default: "Award Amount")
      # @param order   [String] "desc" or "asc" (default: "desc")
      # @param limit   [Integer] results per page, max 100 (default: 10)
      # @param page    [Integer] page number for offset pagination (default: 1)
      # @param last_record_unique_id [Integer] cursor for cursor pagination
      # @param last_record_sort_value [String] sort value of the last record
      # @param subawards [Boolean] return subawards instead of prime awards
      #
      # @example Search for contracts
      #   client.awards.search(
      #     filters: { award_type_codes: ["A", "B", "C", "D"] },
      #     limit: 25
      #   )
      #
      # @return [USAspending::Response]
      def search(
        filters: {},
        fields: default_search_fields,
        sort: 'Award Amount',
        order: 'desc',
        limit: 10,
        page: 1,
        last_record_unique_id: nil,
        last_record_sort_value: nil,
        subawards: false
      )
        search_resource.spending_by_award(
          filters: filters, fields: fields, sort: sort, order: order,
          limit: limit, page: page,
          last_record_unique_id: last_record_unique_id,
          last_record_sort_value: last_record_sort_value,
          subawards: subawards
        )
      end

      # Fetch all pages of a search result using cursor pagination.
      # Yields each page's results array to the block.
      #
      # @param limit [Integer] results per page (default: 100 — max allowed)
      # @yield [Array<Hash>] results array from each page
      # @return [void]
      #
      # @example Iterate through all pages
      #   client.awards.search_all(
      #     filters: { award_type_codes: ["A", "B", "C", "D"] }
      #   ) { |results| results.each { |a| puts a["Award ID"] } }
      def search_all(filters: {}, fields: default_search_fields, sort: 'Award Amount',
                     order: 'desc', limit: 100, subawards: false)
        last_id = nil
        last_sort = nil

        loop do
          response = search(
            filters: filters, fields: fields, sort: sort, order: order,
            limit: limit, subawards: subawards,
            last_record_unique_id: last_id,
            last_record_sort_value: last_sort
          )

          results = response.results
          yield results
          break if results.empty? || !response.next_page?

          last_id   = response.last_record_unique_id
          last_sort = results.last&.dig(sort)
        end
      end

      # Spending over time for awards matching filters.
      # Delegates to {Search#spending_over_time}.
      #
      # @param group [String] "fiscal_year", "quarter", or "month"
      # @param filters [Hash]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      def spending_over_time(group: 'fiscal_year', filters: {}, subawards: false)
        search_resource.spending_over_time(group: group, filters: filters, subawards: subawards)
      end

      # Count of awards matching filters.
      # Delegates to {Search#spending_by_award_count}.
      #
      # @param filters [Hash]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      def count(filters: {}, subawards: false)
        search_resource.spending_by_award_count(filters: filters, subawards: subawards)
      end

      # ----------------------------------------------------------------
      # Award detail endpoints (from /api/v2/awards/ namespace)
      # ----------------------------------------------------------------

      # Fetch a single award by its generated_unique_award_id.
      #
      # `GET /api/v2/awards/{award_id}/`
      #
      # @param award_id [String] e.g. "CONT_AWD_N0018923C0001_9700_-NONE-_-NONE-"
      # @return [USAspending::Response]
      def find(award_id)
        get("awards/#{CGI.escape(award_id)}/")
      end

      # Federal accounts associated with an award.
      #
      # POST /api/v2/awards/accounts/
      #
      # @param award_id [String] generated unique award id
      # @param limit    [Integer]
      # @param page     [Integer]
      # @param sort     [String]
      # @param order    [String]
      # @return [USAspending::Response]
      def accounts(award_id:, limit: 10, page: 1, sort: 'total_transaction_obligated_amount', order: 'desc')
        post('awards/accounts/', {
               award_id: award_id, limit: limit, page: page, sort: sort, order: order
             })
      end

      # Funding information for an award.
      #
      # POST /api/v2/awards/funding/
      #
      # @param award_id [String]
      # @param limit    [Integer]
      # @param page     [Integer]
      # @param sort     [String]
      # @param order    [String]
      # @return [USAspending::Response]
      def funding(award_id:, limit: 10, page: 1, sort: 'reporting_fiscal_date', order: 'desc')
        post('awards/funding/', {
               award_id: award_id, limit: limit, page: page, sort: sort, order: order
             })
      end

      # Aggregated funding counts and totals for an award.
      #
      # POST /api/v2/awards/funding_rollup/
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      def funding_rollup(award_id:)
        post('awards/funding_rollup/', { award_id: award_id })
      end

      # Date of the last update to the awards data.
      #
      # GET /api/v2/awards/last_updated/
      #
      # @return [USAspending::Response]
      def last_updated
        get('awards/last_updated/')
      end

      # Transaction count for a specific award.
      #
      # `GET /api/v2/awards/count/transaction/{award_id}/`
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      def transaction_count(award_id)
        get("awards/count/transaction/#{CGI.escape(award_id)}/")
      end

      # Subaward count for a specific award.
      #
      # `GET /api/v2/awards/count/subaward/{award_id}/`
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      def subaward_count(award_id)
        get("awards/count/subaward/#{CGI.escape(award_id)}/")
      end

      # Federal account count for a specific award.
      #
      # `GET /api/v2/awards/count/federal_account/{award_id}/`
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      def federal_account_count(award_id)
        get("awards/count/federal_account/#{CGI.escape(award_id)}/")
      end

      # ----------------------------------------------------------------
      # Award spending endpoints (from /api/v2/award_spending/ namespace)
      # ----------------------------------------------------------------

      # Award spending by recipient.
      #
      # GET /api/v2/award_spending/recipient/
      #
      # @param fiscal_year       [Integer]
      # @param awarding_agency_id [Integer]
      # @return [USAspending::Response]
      def spending_by_recipient(fiscal_year:, awarding_agency_id:)
        get('award_spending/recipient/', {
              fiscal_year: fiscal_year,
              awarding_agency_id: awarding_agency_id
            })
      end

      private

      def search_resource
        @search_resource ||= Search.new(client)
      end

      def default_search_fields
        [
          'Award ID', 'Recipient Name', 'Description',
          'Award Amount', 'Total Outlays', 'Award Type',
          'Awarding Agency', 'Awarding Sub Agency',
          'Contract Award Type', 'issued_date',
          'Last Date to Order',
          'Place of Performance City Code',
          'Place of Performance State Code',
          'def_codes', 'COVID-19 Obligations', 'COVID-19 Outlays',
          'Infrastructure Obligations', 'Infrastructure Outlays'
        ]
      end
    end
  end
end
