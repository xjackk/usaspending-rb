# frozen_string_literal: true

RSpec.describe USAspending::Resources::FinancialSpending do
  subject(:financial) { USAspending.financial_spending }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#major_object_class' do
    it 'gets major object class spending' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      financial.major_object_class(fiscal_year: 2024, funding_agency_id: 1)

      expect(mock_client).to have_received(:get).with(
        'financial_spending/major_object_class/',
        hash_including(fiscal_year: 2024, funding_agency_id: 1)
      )
    end
  end

  describe '#object_class' do
    it 'gets object class spending' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      financial.object_class(fiscal_year: 2024, funding_agency_id: 1)

      expect(mock_client).to have_received(:get).with(
        'financial_spending/object_class/',
        hash_including(fiscal_year: 2024)
      )
    end
  end
end
