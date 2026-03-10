# frozen_string_literal: true

RSpec.describe USAspending::Resources::FederalAccounts do
  subject(:federal_accounts) { USAspending.federal_accounts }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#list' do
    it 'posts federal accounts list' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      federal_accounts.list(limit: 25)

      expect(mock_client).to have_received(:post).with('federal_accounts/', hash_including(limit: 25))
    end
  end

  describe '#find' do
    it 'gets a federal account by code' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      federal_accounts.find('020-0101')

      expect(mock_client).to have_received(:get).with('federal_accounts/020-0101/', {})
    end
  end

  describe '#fiscal_year_snapshot' do
    it 'gets most recent snapshot' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      federal_accounts.fiscal_year_snapshot('020-0101')

      expect(mock_client).to have_received(:get).with('federal_accounts/020-0101/fiscal_year_snapshot/', {})
    end
  end

  describe '#fiscal_year_snapshot_for' do
    it 'gets snapshot for specific year' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      federal_accounts.fiscal_year_snapshot_for('020-0101', 2024)

      expect(mock_client).to have_received(:get).with('federal_accounts/020-0101/fiscal_year_snapshot/2024/', {})
    end
  end

  describe '#program_activities_total' do
    it 'posts program activities total' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      federal_accounts.program_activities_total('020-0101')

      expect(mock_client).to have_received(:post).with(
        'federal_accounts/020-0101/program_activities/total/',
        hash_including(limit: 10)
      )
    end
  end
end
