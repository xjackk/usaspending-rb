# frozen_string_literal: true

module USAspending
  module Resources
    # High-level spending queries with client-side validation.
    # Delegates to {Search} for the actual API calls, adding
    # argument validation and ThePublicTab convenience methods.
    class Spending < Base
      GEOGRAPHIC_SCOPES = %w[country state county congressional_district
                             place_of_performance_zip5].freeze
      CATEGORY_TYPES    = %w[awarding_agency awarding_subagency recipient
                             cfda psc naics country state county
                             congressional_district recipient_duns
                             funding_agency funding_subagency].freeze

      # Geographic spending breakdown.
      #
      # @param scope      [String] "place_of_performance" or "recipient_location"
      # @param geo_layer  [String] one of {GEOGRAPHIC_SCOPES}
      # @param filters    [Hash]
      # @param geo_layer_filters [Array<String>] restrict to specific geos
      # @param subawards  [Boolean]
      # @return [USAspending::Response]
      # @raise [ArgumentError] when scope or geo_layer is invalid
      #
      # @example Congressional district spending
      #   client.spending.by_geography(
      #     scope: "place_of_performance",
      #     geo_layer: "congressional_district",
      #     geo_layer_filters: ["VA-08"],
      #     filters: { fiscal_years: [2025] }
      #   )
      def by_geography(scope:, geo_layer:, filters: {}, geo_layer_filters: [], subawards: false)
        validate_geo_scope!(scope)
        validate_geo_layer!(geo_layer)

        search_resource.spending_by_geography(
          scope: scope, geo_layer: geo_layer, filters: filters,
          geo_layer_filters: geo_layer_filters, subawards: subawards
        )
      end

      # Categorical spending breakdown (agency, NAICS, PSC, CFDA, etc.)
      #
      # @param category  [String] one of {CATEGORY_TYPES}
      # @param filters   [Hash]
      # @param limit     [Integer]
      # @param page      [Integer]
      # @param subawards [Boolean]
      # @return [USAspending::Response]
      # @raise [ArgumentError] when category is invalid
      #
      # @example NAICS breakdown
      #   client.spending.by_category(
      #     category: "naics",
      #     filters: { fiscal_years: [2025] },
      #     limit: 25
      #   )
      def by_category(category:, filters: {}, limit: 10, page: 1, subawards: false)
        validate_category!(category)

        search_resource.spending_by_category(
          category: category, filters: filters, limit: limit,
          page: page, subawards: subawards
        )
      end

      # Convenience: total spending for a congressional district.
      #
      # @param state_abbr [String] e.g. "VA"
      # @param district   [String] e.g. "08" (zero-padded)
      # @param fiscal_years [Array<Integer>]
      # @return [USAspending::Response]
      def for_district(state_abbr:, district:, fiscal_years: [Time.now.year - 1])
        by_geography(
          scope: 'place_of_performance',
          geo_layer: 'congressional_district',
          geo_layer_filters: ["#{state_abbr.upcase}-#{district.rjust(2, '0')}"],
          filters: {
            fiscal_years: fiscal_years,
            award_type_codes: %w[A B C D 02 03 04 05 06 07 08 09 10 11]
          }
        )
      end

      private

      def search_resource
        @search_resource ||= Search.new(client)
      end

      def validate_geo_scope!(scope)
        valid = %w[place_of_performance recipient_location]
        return if valid.include?(scope)

        raise ArgumentError, "scope must be one of: #{valid.join(', ')}"
      end

      def validate_geo_layer!(geo_layer)
        return if GEOGRAPHIC_SCOPES.include?(geo_layer)

        raise ArgumentError, "geo_layer must be one of: #{GEOGRAPHIC_SCOPES.join(', ')}"
      end

      def validate_category!(category)
        return if CATEGORY_TYPES.include?(category)

        raise ArgumentError, "category must be one of: #{CATEGORY_TYPES.join(', ')}"
      end
    end
  end
end
