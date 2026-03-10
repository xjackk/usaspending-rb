# frozen_string_literal: true

module USAspending
  module Resources
    class Autocomplete < Base
      # Awarding agency autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def awarding_agency(search_text, limit: 10)
        post('autocomplete/awarding_agency/', {
               search_text: search_text,
               limit: limit
             })
      end

      # Funding agency autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def funding_agency(search_text, limit: 10)
        post('autocomplete/funding_agency/', {
               search_text: search_text,
               limit: limit
             })
      end

      # Awarding agency + office autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def awarding_agency_office(search_text, limit: 10)
        post('autocomplete/awarding_agency_office/', {
               search_text: search_text,
               limit: limit
             })
      end

      # Funding agency + office autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def funding_agency_office(search_text, limit: 10)
        post('autocomplete/funding_agency_office/', {
               search_text: search_text,
               limit: limit
             })
      end

      # CFDA program autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def cfda(search_text, limit: 10)
        post('autocomplete/cfda/', {
               search_text: search_text,
               limit: limit
             })
      end

      # NAICS code and title autocomplete.
      #
      # @param search_text [String] code fragment or industry description
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def naics(search_text, limit: 10)
        post('autocomplete/naics/', {
               search_text: search_text,
               limit: limit
             })
      end

      # PSC (Product Service Code) autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def psc(search_text, limit: 10)
        post('autocomplete/psc/', {
               search_text: search_text,
               limit: limit
             })
      end

      # Program activity autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def program_activity(search_text, limit: 10)
        post('autocomplete/program_activity/', {
               search_text: search_text,
               limit: limit
             })
      end

      # Recipient name/UEI autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def recipient(search_text, limit: 10)
        post('autocomplete/recipient/', {
               search_text: search_text,
               limit: limit
             })
      end

      # Glossary term autocomplete.
      #
      # @param search_text [String]
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def glossary(search_text, limit: 10)
        post('autocomplete/glossary/', {
               search_text: search_text,
               limit: limit
             })
      end

      # City name autocomplete.
      #
      # @param search_text  [String]
      # @param scope        [String] "recipient_location" or "primary_place_of_performance"
      #                              (default: "recipient_location")
      # @param country_code [String] ISO 3166-1 alpha-3 country code (default: "USA")
      # @param state_code   [String, nil] optional two-letter state abbreviation
      # @param limit        [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def city(search_text, scope: 'recipient_location', country_code: 'USA', state_code: nil, limit: 10)
        filter = { country_code: country_code, scope: scope }
        filter[:state_code] = state_code if state_code
        post('autocomplete/city/', {
               search_text: search_text,
               limit: limit,
               filter: filter
             })
      end

      # Location autocomplete. Used to resolve zip codes to districts.
      #
      # @param search_text [String] zip code, city name, state, etc.
      # @param geo_layer   [String] "state", "county", "city",
      #                             "congressional_district", "zip_code", "country"
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def location(search_text, geo_layer: nil, limit: 10)
        body = { search_text: search_text, limit: limit }
        body[:geo_layer] = geo_layer if geo_layer
        post('autocomplete/location/', body)
      end

      # ------------------------------------------------------------------
      # TAS (Treasury Account Symbol) component autocomplete endpoints
      #
      # Each accounts/* endpoint accepts search_text, limit, and an
      # optional filters hash whose keys are other TAS component values
      # (e.g. ata, aid, bpoa, epoa, a, main, sub).
      # ------------------------------------------------------------------

      # TAS ATA (Allocation Transfer Agency) autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_ata(search_text, filters: {}, limit: 10)
        accounts_autocomplete('ata', search_text, filters, limit)
      end

      # TAS AID (Agency Identifier) autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_aid(search_text, filters: {}, limit: 10)
        accounts_autocomplete('aid', search_text, filters, limit)
      end

      # TAS BPOA (Beginning Period of Availability) autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_bpoa(search_text, filters: {}, limit: 10)
        accounts_autocomplete('bpoa', search_text, filters, limit)
      end

      # TAS EPOA (Ending Period of Availability) autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_epoa(search_text, filters: {}, limit: 10)
        accounts_autocomplete('epoa', search_text, filters, limit)
      end

      # TAS Availability Type Code autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_a(search_text, filters: {}, limit: 10)
        accounts_autocomplete('a', search_text, filters, limit)
      end

      # TAS Main Account Code autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_main(search_text, filters: {}, limit: 10)
        accounts_autocomplete('main', search_text, filters, limit)
      end

      # TAS Sub-Account Code autocomplete.
      #
      # @param search_text [String]
      # @param filters     [Hash] TAS component filters
      # @param limit       [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts_sub(search_text, filters: {}, limit: 10)
        accounts_autocomplete('sub', search_text, filters, limit)
      end

      private

      def accounts_autocomplete(component, search_text, filters, limit)
        body = { search_text: search_text, limit: limit }
        body[:filters] = filters unless filters.nil? || filters.empty?
        post("autocomplete/accounts/#{component}/", body)
      end
    end
  end
end
