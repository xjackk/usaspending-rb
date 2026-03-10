# frozen_string_literal: true

require 'json'

module USAspending
  # Wraps a raw API response body and provides uniform access to results
  # and pagination metadata across the various response formats used by
  # different USAspending endpoints.
  #
  # Includes +Enumerable+, so you can iterate results directly:
  #
  # @example Iterating results
  #   response = USAspending.awards.search(filters: { ... })
  #   response.each { |award| puts award["Recipient Name"] }
  #   response.map  { |award| award["Award Amount"] }
  #   response.first
  #
  # @example Pagination
  #   response.size        # => 10
  #   response.total_count # => 1234
  #   response.next_page?  # => true
  #
  # @example Direct hash access
  #   response["count"]    # => 42
  #   response.dig("page_metadata", "hasNext") # => true
  class Response
    include Enumerable

    # @return [Hash, Array] the raw parsed JSON response body
    attr_reader :raw

    # @return [Integer] the HTTP status code
    attr_reader :status

    # @param body [Hash, Array] parsed JSON response body
    # @param status [Integer] HTTP status code
    def initialize(body, status)
      @raw    = body
      @status = status
    end

    # Yields each result to the block. Enables +Enumerable+ methods
    # (+map+, +select+, +first+, +any?+, etc.).
    # @yield [Hash] each result record
    # @return [Enumerator] if no block given
    def each(&)
      results.each(&)
    end

    # Returns the results array. Handles multiple response conventions:
    # - Hash with "results" or "data" key (most endpoints)
    # - Hash with other collection keys like "codes", "available_periods"
    # - Raw Array response (e.g. recipient/state/)
    # @return [Array<Hash>]
    def results
      return raw if raw.is_a?(Array)

      raw['results'] || raw['data'] || first_array_value || []
    end

    # Number of results on this page.
    # @return [Integer]
    def size
      results.size
    end
    alias length size

    # Whether this page has no results.
    # @return [Boolean]
    def empty?
      results.empty?
    end

    # Total number of records matching the query (not just this page).
    # @return [Integer, nil]
    def total_count
      return nil unless raw.is_a?(Hash)

      raw.dig('page_metadata', 'count') ||
        raw.dig('page_metadata', 'total') ||
        raw['count']
    end

    # Whether another page of results is available.
    # @return [Boolean]
    def next_page?
      return false unless raw.is_a?(Hash)

      raw.dig('page_metadata', 'hasNext') == true
    end

    # @deprecated Use {#next_page?} instead.
    alias has_next_page? next_page?

    # Cursor value for the next page (used in cursor-based pagination).
    # @return [Integer, nil]
    def last_record_unique_id
      return nil unless raw.is_a?(Hash)

      raw.dig('page_metadata', 'last_record_unique_id')
    end

    # Page number of the last page (used in offset-based pagination).
    # @return [Integer, nil]
    def last_page
      return nil unless raw.is_a?(Hash)

      raw.dig('page_metadata', 'last_page')
    end

    # Access the raw response body by key.
    # @param key [String] the response key
    # @return [Object]
    def [](key)
      return nil unless raw.is_a?(Hash)

      raw[key]
    end

    # Deep access into the raw response body.
    # @param keys [Array<String>] nested key path
    # @return [Object]
    def dig(*keys)
      raw.dig(*keys)
    end

    # Returns the raw response body as a Hash.
    # When the body is an Array, wraps it: +{ "results" => array }+.
    # @return [Hash]
    def to_h
      raw.is_a?(Hash) ? raw : { 'results' => raw }
    end

    # Serializes the response to JSON.
    # @return [String]
    def to_json(*)
      to_h.to_json
    end

    # Whether the response status is 2xx.
    # @return [Boolean]
    def success?
      status >= 200 && status < 300
    end

    # Concise representation for IRB/Pry debugging.
    # @return [String]
    def inspect
      "#<#{self.class} status=#{status} size=#{size} total_count=#{total_count.inspect} next_page?=#{next_page?}>"
    end

    private

    # Finds the first Array value in the response hash as a fallback
    # for endpoints that use non-standard keys (e.g. "codes", "available_periods").
    # @return [Array, nil]
    def first_array_value
      return nil unless raw.is_a?(Hash)

      raw.each_value { |v| return v if v.is_a?(Array) }
      nil
    end
  end
end
