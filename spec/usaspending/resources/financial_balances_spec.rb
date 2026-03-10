# frozen_string_literal: true

RSpec.describe USAspending::Resources::FinancialBalances do
  subject(:balances) { USAspending.financial_balances }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#agencies' do
    it 'gets financial balances by agency' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      balances.agencies(funding_agency_identifier: '020', fiscal_year: 2024)

      expect(mock_client).to have_received(:get).with(
        'financial_balances/agencies/',
        { funding_agency_identifier: '020', fiscal_year: 2024 }
      )
    end
  end
end
