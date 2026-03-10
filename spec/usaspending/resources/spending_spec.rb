# frozen_string_literal: true

RSpec.describe USAspending::Resources::Spending do
  subject(:spending) { USAspending.spending }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#by_geography' do
    it 'posts geographic spending query' do
      response_body = { 'results' => [{ 'shape_code' => 'VA-08', 'aggregated_amount' => 1_000_000 }] }
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new(response_body, 200))

      response = spending.by_geography(
        scope: 'place_of_performance',
        geo_layer: 'congressional_district',
        geo_layer_filters: ['VA-08'],
        filters: { fiscal_years: [2024] }
      )

      expect(mock_client).to have_received(:post).with(
        'search/spending_by_geography/',
        hash_including(scope: 'place_of_performance', geo_layer: 'congressional_district')
      )
      expect(response.results.first['shape_code']).to eq('VA-08')
    end

    it 'raises ArgumentError for invalid scope' do
      expect do
        spending.by_geography(scope: 'invalid', geo_layer: 'state')
      end.to raise_error(ArgumentError, /scope must be one of/)
    end

    it 'raises ArgumentError for invalid geo_layer' do
      expect do
        spending.by_geography(scope: 'place_of_performance', geo_layer: 'planet')
      end.to raise_error(ArgumentError, /geo_layer must be one of/)
    end
  end

  describe '#by_category' do
    it 'posts category spending query' do
      response_body = { 'results' => [{ 'id' => 1, 'code' => '541', 'name' => 'Professional Services' }] }
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new(response_body, 200))

      response = spending.by_category(
        category: 'naics',
        filters: { fiscal_years: [2024] },
        limit: 5
      )

      expect(mock_client).to have_received(:post).with(
        'search/spending_by_category/naics/',
        hash_including(limit: 5)
      )
      expect(response.results).to be_an(Array)
    end

    it 'raises ArgumentError for invalid category' do
      expect do
        spending.by_category(category: 'unicorn')
      end.to raise_error(ArgumentError, /category must be one of/)
    end
  end

  describe '#for_district' do
    it 'calls by_geography with district params' do
      response_body = { 'results' => [{ 'aggregated_amount' => 5_000_000 }] }
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new(response_body, 200))

      response = spending.for_district(state_abbr: 'VA', district: '08', fiscal_years: [2024])

      expect(mock_client).to have_received(:post).with(
        'search/spending_by_geography/',
        hash_including(
          geo_layer: 'congressional_district',
          geo_layer_filters: ['VA-08']
        )
      )
      expect(response).to be_a(USAspending::Response)
    end

    it 'zero-pads single-digit district numbers' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      spending.for_district(state_abbr: 'va', district: '8', fiscal_years: [2024])

      expect(mock_client).to have_received(:post).with(
        'search/spending_by_geography/',
        hash_including(geo_layer_filters: ['VA-08'])
      )
    end
  end
end
