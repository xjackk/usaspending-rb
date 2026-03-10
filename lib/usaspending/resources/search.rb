# frozen_string_literal: true

module USAspending
  module Resources
    class Search < Base
      # Returns fields of the filtered awards.
      #
      # @param filters [Hash] USAspending filter object
      # @param fields [Array<String>] fields to return
      # @param sort [String] field to sort by
      # @param order [String] "desc" or "asc"
      # @param limit [Integer] results per page
      # @param page [Integer]
      # @param last_record_unique_id [Integer] cursor pagination
      # @param last_record_sort_value [String] cursor pagination
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Basic award search
      #   client.search.spending_by_award(
      #     filters: { keywords: ["renewable energy"] },
      #     fields: ["Award ID", "Recipient Name", "Award Amount"],
      #     limit: 5
      #   )
      def spending_by_award(filters: {}, fields: [], sort: 'Award Amount', order: 'desc',
                            limit: 10, page: 1, last_record_unique_id: nil,
                            last_record_sort_value: nil, subawards: false)
        body = {
          filters: filters, fields: fields, sort: sort, order: order,
          limit: limit, page: page, subawards: subawards
        }
        if last_record_unique_id
          body[:last_record_unique_id] = last_record_unique_id
          body[:last_record_sort_value] = last_record_sort_value
        end
        post('search/spending_by_award/', body)
      end

      # Returns number of awards in each award type.
      #
      # @param filters [Hash]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_award_count(filters: {}, subawards: false)
        post('search/spending_by_award_count/', { filters: filters, subawards: subawards })
      end

      # Returns spending data grouped by geography (state, county, district).
      #
      # @param scope [String] "place_of_performance" or "recipient_location"
      # @param geo_layer [String] "state", "county", "district", etc.
      # @param filters [Hash]
      # @param geo_layer_filters [Array<String>]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example State-level spending by place of performance
      #   client.search.spending_by_geography(
      #     scope: "place_of_performance",
      #     geo_layer: "state",
      #     filters: { time_period: [{ start_date: "2025-10-01", end_date: "2026-09-30" }] }
      #   )
      def spending_by_geography(scope:, geo_layer:, filters: {}, geo_layer_filters: [], subawards: false)
        body = { scope: scope, geo_layer: geo_layer, filters: filters, subawards: subawards }
        body[:geo_layer_filters] = geo_layer_filters if geo_layer_filters.any?
        post('search/spending_by_geography/', body)
      end

      # Returns spending data grouped by category.
      # Use the specific category methods below for typed access.
      #
      # @param category [String]
      # @param filters [Hash]
      # @param limit [Integer]
      # @param page [Integer]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_category(category: nil, filters: {}, limit: 10, page: 1, subawards: false)
        path = category ? "search/spending_by_category/#{category}/" : 'search/spending_by_category/'
        post(path, { filters: filters, limit: limit, page: page, subawards: subawards })
      end

      # @!macro [attach] category_method
      #   Spending by $1.
      #   @param filters [Hash]
      #   @param limit [Integer]
      #   @param page [Integer]
      #   @param subawards [Boolean]
      #   @return [USAspending::Response]
      #   @raise [USAspending::ClientError] on 4xx responses
      #   @raise [USAspending::ServerError] on 5xx responses
      #   @raise [USAspending::ConnectionError] on network failures
      CATEGORIES = %w[
        awarding_agency awarding_subagency funding_agency funding_subagency
        recipient recipient_duns cfda naics psc federal_account
        country state_territory county district defc
      ].freeze

      CATEGORIES.each do |cat|
        define_method(:"spending_by_#{cat}") do |filters: {}, limit: 10, page: 1, subawards: false|
          spending_by_category(category: cat, filters: filters, limit: limit, page: page, subawards: subawards)
        end
      end

      # Returns transaction aggregated amounts for Spending Over Time visualizations.
      #
      # @param group [String] "fiscal_year", "quarter", or "month"
      # @param filters [Hash]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Spending grouped by fiscal year
      #   client.search.spending_over_time(
      #     group: "fiscal_year",
      #     filters: { keywords: ["infrastructure"] }
      #   )
      def spending_over_time(group: 'fiscal_year', filters: {}, subawards: false)
        post('search/spending_over_time/', { group: group, filters: filters, subawards: subawards })
      end

      # Returns list of time periods with the new awards count.
      #
      # @param group [String] "fiscal_year", "quarter", or "month"
      # @param filters [Hash]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example New awards per fiscal year for a keyword
      #   client.search.new_awards_over_time(
      #     group: "fiscal_year",
      #     filters: { keywords: ["solar"] }
      #   )
      def new_awards_over_time(group: 'fiscal_year', filters: {})
        post('search/new_awards_over_time/', { group: group, filters: filters })
      end

      # Returns awards where a field matches a search term (keyword search).
      #
      # @param filters [Hash]
      # @param fields [Array<String>]
      # @param sort [String]
      # @param order [String]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_transaction(filters: {}, fields: [], sort: 'Transaction Amount',
                                  order: 'desc', limit: 10, page: 1)
        post('search/spending_by_transaction/', {
               filters: filters, fields: fields, sort: sort, order: order, limit: limit, page: page
             })
      end

      # Returns counts of awards matching a transaction search.
      #
      # @param filters [Hash]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_transaction_count(filters: {})
        post('search/spending_by_transaction_count/', { filters: filters })
      end

      # Returns transactions grouped by their prime award.
      #
      # @param filters [Hash]
      # @param fields [Array<String>]
      # @param sort [String]
      # @param order [String]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_transaction_grouped(filters: {}, fields: [], sort: 'Transaction Amount',
                                          order: 'desc', limit: 10, page: 1)
        post('search/spending_by_transaction_grouped/', {
               filters: filters, fields: fields, sort: sort, order: order, limit: limit, page: page
             })
      end

      # Returns award id, number of subawards, and total subaward obligations.
      #
      # @param filters [Hash]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def spending_by_subaward_grouped(filters: {}, limit: 10, page: 1)
        post('search/spending_by_subaward_grouped/', { filters: filters, limit: limit, page: page })
      end

      # Returns number of transactions and sum of federal action obligations.
      #
      # @param filters [Hash]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def transaction_spending_summary(filters: {})
        post('search/transaction_spending_summary/', { filters: filters })
      end
    end
  end
end
