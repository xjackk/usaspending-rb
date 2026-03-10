# frozen_string_literal: true

module USAspending
  # Holds configuration options for the USAspending client.
  #
  # @example
  #   USAspending.configure do |config|
  #     config.base_url = "https://api.usaspending.gov/api/v2/"
  #     config.timeout  = 60
  #     config.retries  = 5
  #     config.logger   = Logger.new($stdout)
  #   end
  class Configuration
    DEFAULT_BASE_URL = 'https://api.usaspending.gov/api/v2/'
    DEFAULT_TIMEOUT  = 30
    DEFAULT_RETRIES  = 3

    # @return [String] base URL for the USAspending API
    attr_accessor :base_url

    # @return [Integer] request timeout in seconds
    attr_accessor :timeout

    # @return [Integer] maximum number of retries on 429/5xx responses
    attr_accessor :retries

    # @return [Logger, nil] optional logger for request/response logging
    attr_accessor :logger

    # @return [Symbol] Faraday adapter to use (default: Faraday.default_adapter)
    attr_accessor :adapter

    def initialize
      @base_url = DEFAULT_BASE_URL
      @timeout  = DEFAULT_TIMEOUT
      @retries  = DEFAULT_RETRIES
      @logger   = nil
      @adapter  = Faraday.default_adapter
    end

    # @return [Hash] configuration as a plain hash
    def to_h
      {
        base_url: base_url,
        timeout: timeout,
        retries: retries,
        logger: logger,
        adapter: adapter
      }
    end

    # Concise representation for IRB/Pry debugging.
    # @return [String]
    def inspect
      "#<#{self.class} base_url=#{base_url.inspect} timeout=#{timeout} retries=#{retries}>"
    end
  end
end
