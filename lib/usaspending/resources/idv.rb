# frozen_string_literal: true

module USAspending
  module Resources
    class Idv < Base
      # Returns list of federal accounts for the indicated IDV.
      #
      # @param award_id [String] generated unique award ID
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts(award_id:, limit: 10, page: 1)
        post('idvs/accounts/', { award_id: award_id, limit: limit, page: page })
      end

      # Returns information about child awards and grandchild awards for an IDV.
      #
      # @param award_id [String]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def activity(award_id:, limit: 10, page: 1)
        post('idvs/activity/', { award_id: award_id, limit: limit, page: page })
      end

      # Returns the direct children amounts of an IDV.
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def amounts(award_id)
        get("idvs/amounts/#{award_id}/")
      end

      # Returns IDVs or contracts related to the requested IDV.
      #
      # @param award_id [String]
      # @param type [String] "child_idvs" or "child_awards"
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def awards(award_id:, type: 'child_awards', limit: 10, page: 1)
        post('idvs/awards/', { award_id: award_id, type: type, limit: limit, page: page })
      end

      # Returns number of federal accounts associated with IDV children/grandchildren.
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def federal_account_count(award_id)
        get("idvs/count/federal_account/#{award_id}/")
      end

      # Returns File C funding records associated with an IDV.
      #
      # @param award_id [String]
      # @param limit [Integer]
      # @param page [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def funding(award_id:, limit: 10, page: 1)
        post('idvs/funding/', { award_id: award_id, limit: limit, page: page })
      end

      # Returns aggregated count for all contracts under an IDV.
      #
      # @param award_id [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def funding_rollup(award_id:)
        post('idvs/funding_rollup/', { award_id: award_id })
      end
    end
  end
end
