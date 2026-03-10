# frozen_string_literal: true

module USAspending
  module Resources
    class Subawards < Base
      # Returns subawards related to a specific parent award or all awards.
      #
      # @param award_id [String] parent award ID (optional for broad search)
      # @param limit [Integer]
      # @param page [Integer]
      # @param sort [String]
      # @param order [String] "asc" or "desc"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list(award_id: nil, limit: 10, page: 1, sort: 'subaward_number', order: 'desc')
        body = { limit: limit, page: page, sort: sort, order: order }
        body[:award_id] = award_id if award_id
        post('subawards/', body)
      end
    end
  end
end
