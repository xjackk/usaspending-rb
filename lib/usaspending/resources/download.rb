# frozen_string_literal: true

module USAspending
  module Resources
    class Download < Base
      # Generates zip file for download of award data in CSV format.
      #
      # @param filters [Hash]
      # @param columns [Array<String>]
      # @param file_format [String] "csv" or "tsv"
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def awards(filters: {}, columns: [], file_format: 'csv')
        body = { filters: filters, file_format: file_format }
        body[:columns] = columns if columns.any?
        post('download/awards/', body)
      end

      # Generates zip file for download of transaction data in CSV format.
      #
      # @param filters [Hash]
      # @param columns [Array<String>]
      # @param file_format [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def transactions(filters: {}, columns: [], file_format: 'csv')
        body = { filters: filters, file_format: file_format }
        body[:columns] = columns if columns.any?
        post('download/transactions/', body)
      end

      # Generates zip file for download of account data in CSV format.
      #
      # @param account_level [String] "treasury_account" or "federal_account"
      # @param filters [Hash]
      # @param file_format [String]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def accounts(account_level:, filters: {}, file_format: 'csv')
        post('download/accounts/', {
               account_level: account_level, filters: filters, file_format: file_format
             })
      end

      # Returns zipped file containing Contract data.
      #
      # @param award_id [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def contract(award_id:)
        post('download/contract/', { award_id: award_id })
      end

      # Returns zipped file containing Assistance data.
      #
      # @param award_id [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def assistance(award_id:)
        post('download/assistance/', { award_id: award_id })
      end

      # Returns zipped file containing IDV data.
      #
      # @param award_id [Integer]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def idv(award_id:)
        post('download/idv/', { award_id: award_id })
      end

      # Returns zipped file containing Disaster funding data.
      #
      # @param filters [Hash]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def disaster(filters: {})
        post('download/disaster/', { filters: filters })
      end

      # Returns zipped file containing Disaster Recipient funding data.
      #
      # @param filters [Hash]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def disaster_recipients(filters: {})
        post('download/disaster/recipients/', { filters: filters })
      end

      # Returns number of transactions for given filters.
      #
      # @param filters [Hash]
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def count(filters: {})
        post('download/count/', { filters: filters })
      end

      # Gets current status of a download job.
      #
      # @param file_name [String] the download job file name
      # @return [USAspending::Response]
      # @raise [USAspending::ClientError] on 4xx responses
      # @raise [USAspending::ServerError] on 5xx responses
      # @raise [USAspending::ConnectionError] on network failures
      def status(file_name)
        get('download/status/', { file_name: file_name })
      end
    end
  end
end
