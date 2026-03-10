# frozen_string_literal: true

RSpec.describe USAspending::Resources::Awards do
  subject(:awards) { USAspending.awards }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#search' do
    it 'posts to search/spending_by_award/ with filters' do
      response_body = { 'results' => [{ 'Award ID' => '123' }], 'page_metadata' => { 'hasNext' => false } }
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new(response_body, 200))

      response = awards.search(filters: { award_type_codes: %w[A B C D] }, limit: 5)

      expect(mock_client).to have_received(:post).with('search/spending_by_award/', hash_including(limit: 5))
      expect(response.results).to be_an(Array)
    end
  end

  describe '#find' do
    it 'gets a single award by ID' do
      response_body = { 'id' => 123, 'generated_unique_award_id' => 'CONT_AWD_123' }
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new(response_body, 200))

      response = awards.find('CONT_AWD_123')

      expect(mock_client).to have_received(:get).with('awards/CONT_AWD_123/', {})
      expect(response['id']).to eq(123)
    end
  end

  describe '#accounts' do
    it 'posts to awards/accounts/' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      awards.accounts(award_id: 'CONT_AWD_123')

      expect(mock_client).to have_received(:post).with('awards/accounts/', hash_including(award_id: 'CONT_AWD_123'))
    end
  end

  describe '#funding' do
    it 'posts to awards/funding/' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      awards.funding(award_id: 'CONT_AWD_123')

      expect(mock_client).to have_received(:post).with('awards/funding/', hash_including(award_id: 'CONT_AWD_123'))
    end
  end

  describe '#funding_rollup' do
    it 'posts to awards/funding_rollup/' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      awards.funding_rollup(award_id: 'CONT_AWD_123')

      expect(mock_client).to have_received(:post).with('awards/funding_rollup/', { award_id: 'CONT_AWD_123' })
    end
  end

  describe '#last_updated' do
    it 'gets awards/last_updated/' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'last_updated' => '2024-01-01' }, 200))

      response = awards.last_updated

      expect(mock_client).to have_received(:get).with('awards/last_updated/', {})
      expect(response['last_updated']).to eq('2024-01-01')
    end
  end

  describe '#transaction_count' do
    it 'gets transaction count for an award' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'count' => 5 }, 200))

      awards.transaction_count('CONT_AWD_123')

      expect(mock_client).to have_received(:get).with('awards/count/transaction/CONT_AWD_123/', {})
    end
  end

  describe '#subaward_count' do
    it 'gets subaward count for an award' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'count' => 3 }, 200))

      awards.subaward_count('CONT_AWD_123')

      expect(mock_client).to have_received(:get).with('awards/count/subaward/CONT_AWD_123/', {})
    end
  end

  describe '#federal_account_count' do
    it 'gets federal account count for an award' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'count' => 2 }, 200))

      awards.federal_account_count('CONT_AWD_123')

      expect(mock_client).to have_received(:get).with('awards/count/federal_account/CONT_AWD_123/', {})
    end
  end

  describe '#spending_by_recipient' do
    it 'gets award spending by recipient' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      awards.spending_by_recipient(fiscal_year: 2024, awarding_agency_id: 1)

      expect(mock_client).to have_received(:get).with(
        'award_spending/recipient/',
        { fiscal_year: 2024, awarding_agency_id: 1 }
      )
    end
  end

  describe '#spending_over_time' do
    it 'posts to search/spending_over_time/' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      awards.spending_over_time(group: 'fiscal_year', filters: { award_type_codes: %w[A] })

      expect(mock_client).to have_received(:post).with('search/spending_over_time/',
                                                       hash_including(group: 'fiscal_year'))
    end
  end

  describe '#count' do
    it 'posts to search/spending_by_award_count/' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 42 }, 200))

      awards.count(filters: { award_type_codes: %w[A] })

      expect(mock_client).to have_received(:post).with('search/spending_by_award_count/', hash_including(:filters))
    end
  end

  describe '#search_all' do
    let(:first_page) do
      {
        'results' => [{ 'Award Amount' => '500', 'id' => 1 }],
        'page_metadata' => { 'hasNext' => true, 'last_record_unique_id' => 99 }
      }
    end
    let(:final_page) do
      {
        'results' => [{ 'Award Amount' => '100', 'id' => 2 }],
        'page_metadata' => { 'hasNext' => false }
      }
    end

    it 'uses cursor pagination across pages' do
      call_count = 0
      allow(mock_client).to receive(:post) do |_path, _body|
        call_count += 1
        USAspending::Response.new(call_count == 1 ? first_page : final_page, 200)
      end

      pages = []
      awards.search_all(filters: {}, limit: 1) { |results| pages << results }

      expect(pages.size).to eq(2)
    end

    it 'passes last_record_unique_id on subsequent pages' do
      bodies = []
      call_count = 0
      allow(mock_client).to receive(:post) do |_path, body|
        call_count += 1
        bodies << body
        USAspending::Response.new(call_count == 1 ? first_page : final_page, 200)
      end

      awards.search_all(filters: {}, limit: 1) { |_results| nil }

      expect(bodies[0]).not_to have_key(:last_record_unique_id)
      expect(bodies[1][:last_record_unique_id]).to eq(99)
    end

    it 'stops when results are empty' do
      empty = { 'results' => [], 'page_metadata' => { 'hasNext' => false } }
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new(empty, 200))

      pages = []
      awards.search_all(filters: {}) { |results| pages << results }

      expect(pages.size).to eq(1)
    end
  end
end
