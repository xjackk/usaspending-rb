# frozen_string_literal: true

RSpec.describe USAspending::Resources::Subawards do
  subject(:subawards) { USAspending.subawards }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#list' do
    it 'posts subawards list with award_id' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      subawards.list(award_id: 'CONT_AWD_123', limit: 25)

      expect(mock_client).to have_received(:post).with('subawards/',
                                                       hash_including(award_id: 'CONT_AWD_123', limit: 25))
    end

    it 'posts subawards list without award_id' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      subawards.list

      expect(mock_client).to have_received(:post).with('subawards/', hash_excluding(:award_id))
    end
  end
end
