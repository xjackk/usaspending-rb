# frozen_string_literal: true

module USAspending
  module Resources
    class BudgetFunctions < Base
      # Returns all Budget Functions associated with a TAS.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list
        get('budget_functions/list_budget_functions/')
      end

      # Returns all Budget Subfunctions associated with a TAS, ordered by code.
      #
      # @param budget_function [String] budget function code to filter by
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def subfunctions(budget_function:)
        post('budget_functions/list_budget_subfunctions/', { budget_function: budget_function })
      end
    end
  end
end
