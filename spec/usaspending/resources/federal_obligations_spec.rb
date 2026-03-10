# frozen_string_literal: true

RSpec.describe USAspending::Resources::FederalObligations do
  subject(:obligations) { USAspending.federal_obligations }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#list' do
    it 'gets federal obligations' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      obligations.list(fiscal_year: 2024, funding_agency_id: 1)

      expect(mock_client).to have_received(:get).with(
        'federal_obligations/',
        hash_including(fiscal_year: 2024, funding_agency_id: 1)
      )
    end
  end
end
