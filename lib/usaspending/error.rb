# frozen_string_literal: true

module USAspending
  # Base error class. All gem errors inherit from this.
  class Error < StandardError; end

  # Base class for all HTTP errors (4xx and 5xx).
  # Carries the status code and response body for programmatic handling.
  #
  # @example
  #   begin
  #     USAspending.awards.find("INVALID")
  #   rescue USAspending::HttpError => e
  #     puts e.status # => 404
  #     puts e.body   # => { "detail" => "..." }
  #   end
  class HttpError < Error
    # @return [Integer, nil] the HTTP status code
    attr_reader :status

    # @return [Hash, String, nil] the response body
    attr_reader :body

    # @param message [String, nil] error message
    # @param status [Integer, nil] HTTP status code
    # @param body [Hash, String, nil] response body
    def initialize(message = nil, status: nil, body: nil)
      @status = status
      @body   = body
      super(message || default_message)
    end

    private

    def default_message
      "HTTP #{status}: #{body}"
    end
  end

  # Raised when the API returns a 4xx response.
  class ClientError < HttpError; end

  # Raised when the API returns a 400 (bad request / malformed params).
  class BadRequestError < ClientError; end

  # Raised when the API returns a 404.
  class NotFoundError < ClientError; end

  # Raised when the API returns a 422 (invalid filter params).
  class UnprocessableEntityError < ClientError; end

  # Raised when the API returns a 429 and retries are exhausted.
  class RateLimitError < ClientError; end

  # Raised when the API returns a 5xx response after retries are exhausted.
  class ServerError < HttpError
    private

    def default_message
      "Server error HTTP #{status}"
    end
  end

  # Raised on network-level failures (timeout, connection refused, DNS, etc.).
  class ConnectionError < Error; end
end
