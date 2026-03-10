# frozen_string_literal: true

module USAspending
  module Resources
    class FederalAccounts < Base
      # Returns paginated list of federal accounts.
      #
      # @param filters [Hash] filter criteria
      # @param sort [Hash] sort options
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list(filters: {}, sort: {}, limit: 10, page: 1)
        post('federal_accounts/', { filters: filters, sort: sort, limit: limit, page: page })
      end

      # Returns a federal account based on its account code.
      #
      # @param account_code [String] e.g. "020-0101"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def find(account_code)
        get("federal_accounts/#{account_code}/")
      end

      # Returns financial spending data by object class for an account.
      #
      # @param account_code [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def available_object_classes(account_code)
        get("federal_accounts/#{account_code}/available_object_classes/")
      end

      # Returns budget information for a federal account for the most recent year.
      #
      # @param account_id [Integer, String] numeric federal account ID (not account_code).
      #   Use {#find} first to get the +id+ from an account_code.
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def fiscal_year_snapshot(account_id)
        get("federal_accounts/#{account_id}/fiscal_year_snapshot/")
      end

      # Returns budget information for a federal account for the specified year.
      #
      # @param account_id [Integer, String] numeric federal account ID (not account_code).
      #   Use {#find} first to get the +id+ from an account_code.
      # @param year [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def fiscal_year_snapshot_for(account_id, year)
        get("federal_accounts/#{account_id}/fiscal_year_snapshot/#{year}/")
      end

      # Returns list of program activities under a federal account.
      #
      # @param account_code [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def program_activities(account_code)
        get("federal_accounts/#{account_code}/program_activities/")
      end

      # Returns list of program activities with sum of obligations.
      #
      # @param account_code [String]
      # @param filters [Hash]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def program_activities_total(account_code, filters: {}, limit: 10, page: 1)
        post("federal_accounts/#{account_code}/program_activities/total/", {
               filters: filters, limit: limit, page: page
             })
      end

      # Returns list of object classes with sum of obligations.
      #
      # @param account_code [String]
      # @param filters [Hash]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def object_classes_total(account_code, filters: {}, limit: 10, page: 1)
        post("federal_accounts/#{account_code}/object_classes/total/", {
               filters: filters, limit: limit, page: page
             })
      end
    end
  end
end
