# frozen_string_literal: true

module USAspending
  module Resources
    class Agency < Base
      # ------------------------------------------------------------------
      # 1. Agency overview including budget, obligations, outlay totals.
      #    `GET /api/v2/agency/{toptier_code}/`
      #
      # @param toptier_code [String] e.g. "020" for Treasury, "097" for DoD
      # @param fiscal_year  [Integer] defaults to most recent available
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      #
      # @example Fetch Treasury Department overview
      #   client = USAspending::Client.new
      #   response = client.agency.overview("020", fiscal_year: 2024)
      #   response.data["agency_name"] #=> "Department of the Treasury"
      def overview(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 2. Awards summary for an agency.
      #    `GET /api/v2/agency/{toptier_code}/awards/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def awards(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/awards/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 3. Count of new awards for an agency.
      #    `GET /api/v2/agency/{toptier_code}/awards/new/count/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def new_awards_count(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/awards/new/count/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 4. Award type counts (not scoped to a single agency).
      #    GET /api/v2/agency/awards/count/
      #
      # @param fiscal_year [Integer]
      # @return [USAspending::Response]
      def awards_count(fiscal_year: nil)
        get('agency/awards/count/', fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 5. Budget functions list for an agency.
      #    `GET /api/v2/agency/{toptier_code}/budget_function/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def budget_function(toptier_code, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/budget_function/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 6. Count of budget functions for an agency.
      #    `GET /api/v2/agency/{toptier_code}/budget_function/count/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def budget_function_count(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/budget_function/count/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 7. Budgetary resources for an agency across fiscal years.
      #    `GET /api/v2/agency/{toptier_code}/budgetary_resources/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def budgetary_resources(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/budgetary_resources/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 8. Federal account breakdown for an agency.
      #    `GET /api/v2/agency/{toptier_code}/federal_account/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def federal_accounts(toptier_code, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/federal_account/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 9. Count of federal accounts for an agency.
      #    `GET /api/v2/agency/{toptier_code}/federal_account/count/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def federal_account_count(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/federal_account/count/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 10. Object classes for an agency.
      #     `GET /api/v2/agency/{toptier_code}/object_class/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def object_class(toptier_code, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/object_class/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 11. Count of object classes for an agency.
      #     `GET /api/v2/agency/{toptier_code}/object_class/count/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def object_class_count(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/object_class/count/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 12. Obligations breakdown by award category.
      #     `GET /api/v2/agency/{toptier_code}/obligations_by_award_category/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def obligations_by_award_category(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/obligations_by_award_category/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 13. Program activities for an agency.
      #     `GET /api/v2/agency/{toptier_code}/program_activity/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def program_activity(toptier_code, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/program_activity/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 14. Count of program activities for an agency.
      #     `GET /api/v2/agency/{toptier_code}/program_activity/count/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def program_activity_count(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/program_activity/count/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 15. Sub-agencies for a given top-tier agency.
      #     `GET /api/v2/agency/{toptier_code}/sub_agency/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def sub_agencies(toptier_code, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/sub_agency/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 16. Count of sub-agencies for an agency.
      #     `GET /api/v2/agency/{toptier_code}/sub_agency/count/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @return [USAspending::Response]
      def sub_agency_count(toptier_code, fiscal_year: nil)
        get("agency/#{toptier_code}/sub_agency/count/", fy_params(fiscal_year))
      end

      # ------------------------------------------------------------------
      # 17. Bureaus (sub-components) for an agency.
      #     `GET /api/v2/agency/{toptier_code}/sub_components/`
      #
      # @param toptier_code [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def sub_components(toptier_code, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/sub_components/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 18. Federal accounts for a specific bureau within an agency.
      #     `GET /api/v2/agency/{toptier_code}/sub_components/{bureau_slug}/`
      #
      # @param toptier_code [String]
      # @param bureau_slug  [String]
      # @param fiscal_year  [Integer]
      # @param limit        [Integer]
      # @param page         [Integer]
      # @return [USAspending::Response]
      def sub_component_federal_accounts(toptier_code, bureau_slug, fiscal_year: nil, limit: 10, page: 1)
        get("agency/#{toptier_code}/sub_components/#{bureau_slug}/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 19. Object classes for a Treasury Account Symbol (TAS).
      #     `GET /api/v2/agency/treasury_account/{tas}/object_class/`
      #
      # @param tas         [String] Treasury Account Symbol
      # @param fiscal_year [Integer]
      # @param limit       [Integer]
      # @param page        [Integer]
      # @return [USAspending::Response]
      def treasury_account_object_class(tas, fiscal_year: nil, limit: 10, page: 1)
        get("agency/treasury_account/#{tas}/object_class/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # 20. Program activities for a Treasury Account Symbol (TAS).
      #     `GET /api/v2/agency/treasury_account/{tas}/program_activity/`
      #
      # @param tas         [String] Treasury Account Symbol
      # @param fiscal_year [Integer]
      # @param limit       [Integer]
      # @param page        [Integer]
      # @return [USAspending::Response]
      def treasury_account_program_activity(tas, fiscal_year: nil, limit: 10, page: 1)
        get("agency/treasury_account/#{tas}/program_activity/", fy_params(fiscal_year, limit: limit, page: page))
      end

      # ------------------------------------------------------------------
      # List all top-tier agencies with their toptier_codes.
      # GET /api/v2/references/toptier_agencies/
      #
      # @return [USAspending::Response]
      def list
        get('references/toptier_agencies/')
      end

      private

      # Builds query params hash with optional fiscal_year and any extras.
      # @param fiscal_year [Integer, nil]
      # @param extras [Hash] additional params (limit, page, etc.)
      # @return [Hash]
      def fy_params(fiscal_year, **extras)
        params = extras.dup
        params[:fiscal_year] = fiscal_year if fiscal_year
        params
      end
    end
  end
end
