# frozen_string_literal: true

module USAspending
  module Resources
    class References < Base
      # 1. Agency information by ID.
      #
      # @param agency_id [Integer, String] toptier agency ID
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def agency(agency_id)
        get("references/agency/#{agency_id}/")
      end

      # 2. All assistance listings (formerly CFDA programs).
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def assistance_listings
        get('references/assistance_listing/')
      end

      # 3. A specific assistance listing by CFDA number.
      #
      # @param cfda [String] CFDA number (e.g. "10.553")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def assistance_listing(cfda)
        get("references/assistance_listing/#{cfda}/")
      end

      # 4. Award type code-to-label mappings.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def award_types
        get('references/award_types/')
      end

      # 5. CFDA spend totals for all programs.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def cfda_totals
        get('references/cfda/totals/')
      end

      # 6. CFDA spend totals for a specific program.
      #
      # @param cfda [String] CFDA number (e.g. "10.553")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def cfda_total(cfda)
        get("references/cfda/totals/#{cfda}/")
      end

      # 7. Rosetta Crosswalk Data Dictionary.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def data_dictionary
        get('references/data_dictionary/')
      end

      # 8. Disaster Emergency Fund Codes (DEFC) — COVID, IIJA, etc.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example List all Disaster Emergency Fund Codes
      #   client = USAspending::Client.new
      #   response = client.references.def_codes
      #   response.data.each { |code| puts "#{code['code']}: #{code['title']}" }
      def def_codes
        get('references/def_codes/')
      end

      # 9. Generate a hash for a set of filter parameters.
      #
      # @param filters [Hash] filter parameters to hash
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def filter(filters)
        post('references/filter/', filters)
      end

      # 10–13. Product and Service Code (PSC) filter tree.
      #
      # Called with no arguments returns top-level PSC groups.
      # Each successive tier narrows the tree:
      #   psc_tree              — top-level groups
      #   psc_tree("A")         — tier-1 children
      #   psc_tree("A", "B")    — tier-2 children
      #   psc_tree("A", "B", "C") — tier-3 children
      #
      # @param tier1 [String, nil] first-tier PSC code
      # @param tier2 [String, nil] second-tier PSC code
      # @param tier3 [String, nil] third-tier PSC code
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def psc_tree(tier1 = nil, tier2 = nil, tier3 = nil)
        path = 'references/filter_tree/psc/'
        path += "#{tier1}/" if tier1
        path += "#{tier2}/" if tier2
        path += "#{tier3}/" if tier3
        get(path)
      end

      # 14–17. Treasury Account Symbol (TAS) filter tree.
      #
      # Called with no arguments returns TAS agencies.
      # Each successive parameter narrows the tree:
      #   tas_tree                          — agencies
      #   tas_tree("020")                   — federal accounts
      #   tas_tree("020", "0102")           — TAS symbols
      #   tas_tree("020", "0102", "12345")  — specific TAS
      #
      # @param agency          [String, nil] agency code
      # @param federal_account [String, nil] federal account code
      # @param tas             [String, nil] TAS code
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def tas_tree(agency = nil, federal_account = nil, tas = nil)
        path = 'references/filter_tree/tas/'
        path += "#{agency}/" if agency
        path += "#{federal_account}/" if federal_account
        path += "#{tas}/" if tas
        get(path)
      end

      # 18. Glossary terms.
      #
      # @param limit [Integer] results per page
      # @param page  [Integer] page number
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def glossary(limit: 50, page: 1)
        get('references/glossary/', { limit: limit, page: page })
      end

      # 19. Retrieve a previously stored filter set by its hash.
      #
      # @param hash_value [String] the filter hash
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def hash_filter(hash_value)
        post('references/hash/', { hash: hash_value })
      end

      # 20. All NAICS codes.
      #
      # @param depth [Integer, nil] tree depth to return (nil = all)
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def naics(depth: nil)
        params = {}
        params[:depth] = depth if depth
        get('references/naics/', params)
      end

      # 21. A specific NAICS code with its children.
      #
      # @param naics_code [String, Integer] NAICS code (e.g. "336411")
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def naics_code(naics_code)
        get("references/naics/#{naics_code}/")
      end

      # 22. Submission periods (reporting windows).
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def submission_periods
        get('references/submission_periods/')
      end

      # 23. All toptier agencies.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example List all top-tier agencies
      #   client = USAspending::Client.new
      #   response = client.references.toptier_agencies
      #   response.data["results"].each { |a| puts "#{a['toptier_code']}: #{a['agency_name']}" }
      def toptier_agencies
        get('references/toptier_agencies/')
      end

      # 24. Total budgetary resources broken down by fiscal year.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def total_budgetary_resources
        get('references/total_budgetary_resources/')
      end
    end
  end
end
