# frozen_string_literal: true

RSpec.describe USAspending::Resources::Transactions do
  subject(:transactions) { USAspending.transactions }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#list' do
    it 'posts transactions list' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      transactions.list(award_id: 'CONT_AWD_123', limit: 25)

      expect(mock_client).to have_received(:post).with(
        'transactions/',
        hash_including(award_id: 'CONT_AWD_123', limit: 25)
      )
    end
  end
end
