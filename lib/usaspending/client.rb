# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'json'

module USAspending
  # HTTP client that wraps Faraday with retry logic and error handling.
  # Supports both module-level and per-instance usage patterns.
  #
  # @example Module-level (shared client)
  #   USAspending.awards.search(filters: { ... })
  #
  # @example Per-instance (custom config)
  #   client = USAspending::Client.new(config)
  #   client.awards.search(filters: { ... })
  class Client
    # @return [Configuration] the configuration used by this client
    attr_reader :config

    # @param config [Configuration] configuration object (defaults to global config)
    def initialize(config = USAspending.configuration)
      @config = config
    end

    # Returns the Faraday connection, lazily built.
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(url: config.base_url) do |f|
        f.options.timeout      = config.timeout
        f.options.open_timeout = 10

        f.headers['User-Agent'] = "usaspending-rb/#{USAspending::VERSION}"

        f.request :json
        f.response :json, content_type: /\bjson$/

        f.request :retry,
                  max: config.retries,
                  interval: 0.5,
                  interval_randomness: 0.5,
                  backoff_factor: 2,
                  retry_statuses: [429, 500, 502, 503, 504],
                  exceptions: [
                    Faraday::TimeoutError,
                    Faraday::ConnectionFailed,
                    Faraday::RetriableResponse
                  ]

        f.response :logger, config.logger if config.logger
        f.adapter config.adapter
      end
    end

    # Performs a GET request.
    #
    # @param path [String] API endpoint path relative to base URL
    # @param params [Hash] query parameters
    # @return [Response]
    # @raise [HttpError] on any non-2xx response
    # @raise [ConnectionError] on network failures or timeouts
    def get(path, params = {})
      response = connection.get(path, params)
      handle_response(response)
    rescue Faraday::TimeoutError => e
      raise ConnectionError, "Request timed out: #{e.message}"
    rescue Faraday::ConnectionFailed => e
      raise ConnectionError, "Connection failed: #{e.message}"
    end

    # Performs a POST request with a JSON body.
    #
    # @param path [String] API endpoint path relative to base URL
    # @param body [Hash] request body (serialized to JSON)
    # @return [Response]
    # @raise [HttpError] on any non-2xx response
    # @raise [ConnectionError] on network failures or timeouts
    def post(path, body = {})
      response = connection.post(path, body)
      handle_response(response)
    rescue Faraday::TimeoutError => e
      raise ConnectionError, "Request timed out: #{e.message}"
    rescue Faraday::ConnectionFailed => e
      raise ConnectionError, "Connection failed: #{e.message}"
    end

    # @!group Resource Accessors

    # @!macro [attach] resource_accessor
    #   @return [Resources::$1]
    RESOURCE_ACCESSORS = {
      awards: 'Awards',
      agency: 'Agency',
      spending: 'Spending',
      recipient: 'Recipient',
      autocomplete: 'Autocomplete',
      references: 'References',
      disaster: 'Disaster',
      search: 'Search',
      federal_accounts: 'FederalAccounts',
      download: 'Download',
      bulk_download: 'BulkDownload',
      idv: 'Idv',
      subawards: 'Subawards',
      transactions: 'Transactions',
      spending_explorer: 'SpendingExplorer',
      reporting: 'Reporting',
      federal_obligations: 'FederalObligations',
      financial_balances: 'FinancialBalances',
      financial_spending: 'FinancialSpending',
      budget_functions: 'BudgetFunctions',
      award_spending: 'AwardSpending'
    }.freeze

    RESOURCE_ACCESSORS.each do |method_name, class_name|
      define_method(method_name) do
        ivar = "@#{method_name}"
        instance_variable_get(ivar) || instance_variable_set(ivar, Resources.const_get(class_name).new(self))
      end
    end

    # @!endgroup

    # Concise representation for IRB/Pry debugging.
    # @return [String]
    def inspect
      "#<#{self.class} base_url=#{config.base_url.inspect} timeout=#{config.timeout}>"
    end

    private

    def handle_response(response)
      case response.status
      when 200..299
        Response.new(response.body, response.status)
      when 400
        raise BadRequestError.new(status: response.status, body: response.body)
      when 404
        raise NotFoundError.new(status: response.status, body: response.body)
      when 422
        raise UnprocessableEntityError.new(status: response.status, body: response.body)
      when 429
        raise RateLimitError.new(status: 429, body: response.body)
      when 401..499
        raise ClientError.new(status: response.status, body: response.body)
      when 500..599
        raise ServerError.new(status: response.status, body: response.body)
      else
        raise Error, "Unexpected HTTP status: #{response.status}"
      end
    end
  end
end
