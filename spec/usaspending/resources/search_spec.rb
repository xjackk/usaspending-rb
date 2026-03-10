# frozen_string_literal: true

RSpec.describe USAspending::Resources::Search do
  subject(:search) { USAspending.search }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#spending_by_award' do
    it 'posts award search' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.spending_by_award(filters: { award_type_codes: %w[A] }, limit: 5)

      expect(mock_client).to have_received(:post).with('search/spending_by_award/', hash_including(limit: 5))
    end
  end

  describe '#spending_by_award_count' do
    it 'posts award count' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 10 }, 200))

      search.spending_by_award_count(filters: { award_type_codes: %w[A] })

      expect(mock_client).to have_received(:post).with('search/spending_by_award_count/', hash_including(:filters))
    end
  end

  describe '#spending_by_geography' do
    it 'posts geographic search' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.spending_by_geography(scope: 'place_of_performance', geo_layer: 'state')

      expect(mock_client).to have_received(:post).with('search/spending_by_geography/',
                                                       hash_including(geo_layer: 'state'))
    end
  end

  describe '#spending_by_category' do
    it 'posts category search with specific category' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.spending_by_category(category: 'naics', filters: { fiscal_years: [2024] })

      expect(mock_client).to have_received(:post).with('search/spending_by_category/naics/', hash_including(:filters))
    end
  end

  describe '#spending_by_naics' do
    it 'delegates to spending_by_category' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.spending_by_naics(filters: { fiscal_years: [2024] })

      expect(mock_client).to have_received(:post).with('search/spending_by_category/naics/', hash_including(:filters))
    end
  end

  describe '#spending_over_time' do
    it 'posts spending over time' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.spending_over_time(group: 'quarter', filters: {})

      expect(mock_client).to have_received(:post).with('search/spending_over_time/', hash_including(group: 'quarter'))
    end
  end

  describe '#new_awards_over_time' do
    it 'posts new awards over time' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.new_awards_over_time(group: 'fiscal_year', filters: {})

      expect(mock_client).to have_received(:post).with('search/new_awards_over_time/',
                                                       hash_including(group: 'fiscal_year'))
    end
  end

  describe '#spending_by_transaction' do
    it 'posts transaction search' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      search.spending_by_transaction(filters: {}, limit: 5)

      expect(mock_client).to have_received(:post).with('search/spending_by_transaction/', hash_including(limit: 5))
    end
  end

  describe '#transaction_spending_summary' do
    it 'posts summary' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      search.transaction_spending_summary(filters: {})

      expect(mock_client).to have_received(:post).with('search/transaction_spending_summary/', { filters: {} })
    end
  end
end
