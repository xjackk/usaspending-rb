# frozen_string_literal: true

module USAspending
  module Resources
    class SpendingExplorer < Base
      # Returns spending data through various types and filters.
      # Used to power the Spending Explorer visualization.
      #
      # The API requires +fy+ and either +quarter+ or +period+ in the filters hash.
      #
      # @param type [String] "budget_function", "budget_subfunction", "federal_account",
      #                      "program_activity", "object_class", "recipient", "award",
      #                      "agency"
      # @param filters [Hash] must include +fy+ (String) and +quarter+ (String, "1"-"4")
      #                       or +period+ (String, "2"-"12"). May include nested drill-down keys.
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses (including missing fy/quarter)
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Top-level budget functions for FY2024 Q4
      #   USAspending.spending_explorer.explore(
      #     type: "budget_function",
      #     filters: { fy: "2024", quarter: "4" }
      #   )
      def explore(type:, filters: {})
        post('spending/', { type: type, filters: filters })
      end
    end
  end
end
