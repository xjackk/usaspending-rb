# frozen_string_literal: true

RSpec.describe USAspending::Resources::Idv do
  subject(:idv) { USAspending.idv }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#accounts' do
    it 'posts IDV accounts' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      idv.accounts(award_id: 'IDV_123')

      expect(mock_client).to have_received(:post).with('idvs/accounts/', hash_including(award_id: 'IDV_123'))
    end
  end

  describe '#activity' do
    it 'posts IDV activity' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      idv.activity(award_id: 'IDV_123')

      expect(mock_client).to have_received(:post).with('idvs/activity/', hash_including(award_id: 'IDV_123'))
    end
  end

  describe '#amounts' do
    it 'gets IDV amounts' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      idv.amounts('IDV_123')

      expect(mock_client).to have_received(:get).with('idvs/amounts/IDV_123/', {})
    end
  end

  describe '#awards' do
    it 'posts IDV awards' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      idv.awards(award_id: 'IDV_123', type: 'child_idvs')

      expect(mock_client).to have_received(:post).with('idvs/awards/', hash_including(type: 'child_idvs'))
    end
  end

  describe '#funding' do
    it 'posts IDV funding' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      idv.funding(award_id: 'IDV_123')

      expect(mock_client).to have_received(:post).with('idvs/funding/', hash_including(award_id: 'IDV_123'))
    end
  end

  describe '#funding_rollup' do
    it 'posts IDV funding rollup' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      idv.funding_rollup(award_id: 'IDV_123')

      expect(mock_client).to have_received(:post).with('idvs/funding_rollup/', { award_id: 'IDV_123' })
    end
  end
end
