# frozen_string_literal: true

module USAspending
  module Resources
    class Recipient < Base
      # 1. POST /api/v2/recipient/ — List/search recipients by keyword.
      #
      # @param keyword     [String] name fragment or identifier to search
      # @param award_type  [String] "all", "contracts", "grants", "loans",
      #                              "direct_payments", "other_financial_assistance"
      # @param limit       [Integer]
      # @param page        [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Search for recipients by name
      #   client = USAspending::Client.new
      #   response = client.recipient.search("Lockheed", award_type: "contracts")
      #   response.data["results"].each { |r| puts r["name"] }
      def search(keyword, award_type: 'all', limit: 10, page: 1)
        post('recipient/', {
               keyword: keyword,
               award_type: award_type,
               limit: limit,
               page: page
             })
      end

      # 2. `GET /api/v2/recipient/{hash_value}/` — Recipient overview by hash.
      #
      # @param hash_value [String] USAspending recipient hash (UUID)
      # @param year       [String] fiscal year or "latest" (default: "latest")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Fetch a specific recipient by hash
      #   client = USAspending::Client.new
      #   response = client.recipient.find("abc123-def456", year: "2024")
      #   response.data["name"] #=> "LOCKHEED MARTIN CORPORATION"
      def find(hash_value, year: 'latest')
        get("recipient/#{hash_value}/", { year: year })
      end

      # 3. POST /api/v2/recipient/count/ — Recipient count matching filters.
      #
      # @param filters [Hash] filter criteria
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def count(filters = {})
        post('recipient/count/', filters)
      end

      # 4. `GET /api/v2/recipient/children/{duns_or_uei}/` — Child recipients by DUNS or UEI.
      #
      # @param duns_or_uei [String] parent DUNS number or UEI
      # @param year        [String] fiscal year or "latest" (default: "latest")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def children(duns_or_uei, year: 'latest')
        get("recipient/children/#{duns_or_uei}/", { year: year })
      end

      # 5. POST /api/v2/recipient/duns/ — List recipients by DUNS.
      #
      # @param duns_list [Array<String>] DUNS numbers to look up
      # @param params    [Hash] additional body parameters
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def duns(duns_list, **params)
        post('recipient/duns/', { recipient_id_list: duns_list }.merge(params))
      end

      # 6. `GET /api/v2/recipient/duns/{hash_value}/` — Recipient overview by DUNS hash.
      #
      # @param hash_value [String] DUNS-based recipient hash
      # @param year       [String] fiscal year or "latest" (default: "latest")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def find_by_duns(hash_value, year: 'latest')
        get("recipient/duns/#{hash_value}/", { year: year })
      end

      # 7. GET /api/v2/recipient/state/ — Summary info for all states.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def states
        get('recipient/state/')
      end

      # 8. `GET /api/v2/recipient/state/{fips}/` — Info for a specific state by FIPS code.
      #
      # @param fips [String] two-digit FIPS state code
      # @param year [String] fiscal year or "latest" (default: "latest")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def state(fips, year: 'latest')
        get("recipient/state/#{fips}/", { year: year })
      end

      # 9. `GET /api/v2/recipient/state/awards/{fips}/` — Award breakdown by state FIPS.
      #
      # @param fips [String] two-digit FIPS state code
      # @param year [String] fiscal year or "latest" (default: "latest")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def state_awards(fips, year: 'latest')
        get("recipient/state/awards/#{fips}/", { year: year })
      end
    end
  end
end
