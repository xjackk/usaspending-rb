# frozen_string_literal: true

module USAspending
  module Resources
    # Base class for all API resource classes.
    # Provides shared {#get} and {#post} helpers that delegate to the {Client}.
    #
    # @abstract Subclass and use {#get}/{#post} to implement API methods.
    class Base
      # @param client [Client] the HTTP client to use for requests
      def initialize(client = USAspending.client)
        @client = client
      end

      private

      # @return [Client]
      attr_reader :client

      # @see Client#get
      def get(path, params = {})
        client.get(path, params)
      end

      # @see Client#post
      def post(path, body = {})
        client.post(path, body)
      end
    end
  end
end
