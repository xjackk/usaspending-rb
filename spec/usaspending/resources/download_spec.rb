# frozen_string_literal: true

RSpec.describe USAspending::Resources::Download do
  subject(:download) { USAspending.download }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#awards' do
    it 'posts award download request' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'file_url' => 'https://...' }, 200))

      download.awards(filters: { award_type_codes: %w[A] })

      expect(mock_client).to have_received(:post).with('download/awards/', hash_including(:filters))
    end
  end

  describe '#transactions' do
    it 'posts transaction download request' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      download.transactions(filters: {})

      expect(mock_client).to have_received(:post).with('download/transactions/', hash_including(:filters))
    end
  end

  describe '#accounts' do
    it 'posts account download request' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      download.accounts(account_level: 'federal_account', filters: {})

      expect(mock_client).to have_received(:post).with(
        'download/accounts/',
        hash_including(account_level: 'federal_account')
      )
    end
  end

  describe '#status' do
    it 'gets download status' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'status' => 'complete' }, 200))

      download.status('my_file.zip')

      expect(mock_client).to have_received(:get).with('download/status/', { file_name: 'my_file.zip' })
    end
  end

  describe '#disaster' do
    it 'posts disaster download' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      download.disaster(filters: { def_codes: %w[L] })

      expect(mock_client).to have_received(:post).with('download/disaster/', { filters: { def_codes: %w[L] } })
    end
  end

  describe '#count' do
    it 'posts download count' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 100 }, 200))

      download.count(filters: {})

      expect(mock_client).to have_received(:post).with('download/count/', { filters: {} })
    end
  end
end
