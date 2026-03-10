# frozen_string_literal: true

RSpec.describe USAspending::Resources::Disaster do
  subject(:disaster) { USAspending.disaster }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#overview' do
    it 'gets disaster overview without filters' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      disaster.overview

      expect(mock_client).to have_received(:get).with('disaster/overview/', {})
    end

    it 'gets disaster overview with def_codes' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      disaster.overview(def_codes: %w[L M N])

      expect(mock_client).to have_received(:get).with('disaster/overview/', { def_codes: %w[L M N] })
    end
  end

  describe '#agency_count' do
    it 'posts agency count' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 5 }, 200))

      disaster.agency_count(def_codes: %w[L])

      expect(mock_client).to have_received(:post).with('disaster/agency/count/', { filter: { def_codes: %w[L] } })
    end
  end

  describe '#agency_loans' do
    it 'posts agency loans' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      disaster.agency_loans(def_codes: %w[L M])

      expect(mock_client).to have_received(:post).with(
        'disaster/agency/loans/',
        { filter: { def_codes: %w[L M] }, spending_type: 'total', limit: 10, page: 1 }
      )
    end
  end

  describe '#agency_spending' do
    it 'posts agency spending' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      disaster.agency_spending(def_codes: %w[L M], limit: 25)

      expect(mock_client).to have_received(:post).with(
        'disaster/agency/spending/',
        { filter: { def_codes: %w[L M] }, spending_type: 'total', limit: 25, page: 1 }
      )
    end
  end

  describe '#award_amount' do
    it 'posts award amount' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      disaster.award_amount(def_codes: %w[L])

      expect(mock_client).to have_received(:post).with('disaster/award/amount/', { filter: { def_codes: %w[L] } })
    end
  end

  describe '#award_count' do
    it 'posts award count' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 10 }, 200))

      disaster.award_count(def_codes: %w[L])

      expect(mock_client).to have_received(:post).with('disaster/award/count/', { filter: { def_codes: %w[L] } })
    end
  end

  describe '#cfda_count' do
    it 'posts CFDA count' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 3 }, 200))

      disaster.cfda_count(def_codes: %w[L])

      expect(mock_client).to have_received(:post).with('disaster/cfda/count/', { filter: { def_codes: %w[L] } })
    end
  end

  describe '#federal_account_spending' do
    it 'posts federal account spending' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      disaster.federal_account_spending(def_codes: %w[N])

      expect(mock_client).to have_received(:post).with(
        'disaster/federal_account/spending/',
        { filter: { def_codes: %w[N] }, spending_type: 'total', limit: 10, page: 1 }
      )
    end
  end

  describe '#recipient_loans' do
    it 'posts recipient loans' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      disaster.recipient_loans(def_codes: %w[L M])

      expect(mock_client).to have_received(:post).with(
        'disaster/recipient/loans/',
        { filter: { def_codes: %w[L M] }, spending_type: 'total', limit: 10, page: 1 }
      )
    end
  end

  describe '#spending_by_geography' do
    it 'posts geographic disaster spending' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      disaster.spending_by_geography(def_codes: %w[L], geo_layer: 'state')

      expect(mock_client).to have_received(:post).with(
        'disaster/spending_by_geography/',
        hash_including(filter: { def_codes: %w[L] }, geo_layer: 'state')
      )
    end
  end
end
