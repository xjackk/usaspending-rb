# frozen_string_literal: true

module USAspending
  module Resources
    class Transactions < Base
      # Returns transactions related to a specific parent award.
      #
      # @param award_id [String] parent award ID
      # @param limit [Integer]
      # @param page [Integer]
      # @param sort [String]
      # @param order [String] "asc" or "desc"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list(award_id:, limit: 10, page: 1, sort: 'action_date', order: 'desc')
        post('transactions/', {
               award_id: award_id, limit: limit, page: page, sort: sort, order: order
             })
      end
    end
  end
end
