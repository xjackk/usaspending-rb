# frozen_string_literal: true

module USAspending
  module Resources
    class BulkDownload < Base
      # Generates zip file for bulk download of award data in CSV format.
      #
      # @param filters [Hash]
      # @param file_format [String] "csv" or "tsv"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def awards(filters: {}, file_format: 'csv')
        post('bulk_download/awards/', { filters: filters, file_format: file_format })
      end

      # Lists all agencies and subagencies or federal accounts associated with bulk download.
      #
      # @param agency [Integer] agency database ID
      # @param type [String] "account_agencies" or "award_agencies"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list_agencies(agency: nil, type: 'award_agencies')
        body = { type: type }
        body[:agency] = agency if agency
        post('bulk_download/list_agencies/', body)
      end

      # Lists monthly files associated with requested params.
      #
      # @param agency [Integer]
      # @param fiscal_year [Integer]
      # @param type [String] "contracts" or "assistance"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list_monthly_files(agency:, fiscal_year:, type: 'contracts')
        post('bulk_download/list_monthly_files/', {
               agency: agency, fiscal_year: fiscal_year, type: type
             })
      end

      # Lists unlinked awards download files.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list_unlinked_awards_files(**params)
        post('bulk_download/list_unlinked_awards_files/', params)
      end

      # Lists database download files.
      #
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def list_database_download_files(**params)
        post('bulk_download/list_database_download_files/', params)
      end

      # Returns current status of a bulk download job.
      #
      # @param file_name [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def status(file_name)
        get('bulk_download/status/', { file_name: file_name })
      end
    end
  end
end
