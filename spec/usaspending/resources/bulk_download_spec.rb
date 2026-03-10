# frozen_string_literal: true

RSpec.describe USAspending::Resources::BulkDownload do
  subject(:bulk_download) { USAspending.bulk_download }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#awards' do
    it 'posts bulk award download' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({}, 200))

      bulk_download.awards(filters: {})

      expect(mock_client).to have_received(:post).with('bulk_download/awards/', hash_including(:filters))
    end
  end

  describe '#list_agencies' do
    it 'posts list agencies request' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      bulk_download.list_agencies(type: 'award_agencies')

      expect(mock_client).to have_received(:post).with('bulk_download/list_agencies/', { type: 'award_agencies' })
    end
  end

  describe '#list_monthly_files' do
    it 'posts list monthly files' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      bulk_download.list_monthly_files(agency: 1, fiscal_year: 2024)

      expect(mock_client).to have_received(:post).with(
        'bulk_download/list_monthly_files/',
        { agency: 1, fiscal_year: 2024, type: 'contracts' }
      )
    end
  end

  describe '#status' do
    it 'gets bulk download status' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'status' => 'ready' }, 200))

      bulk_download.status('file.zip')

      expect(mock_client).to have_received(:get).with('bulk_download/status/', { file_name: 'file.zip' })
    end
  end
end
