# frozen_string_literal: true

RSpec.describe USAspending::Resources::AwardSpending do
  subject(:award_spending) { USAspending.award_spending }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#by_recipient' do
    it 'gets award spending by recipient' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      award_spending.by_recipient(fiscal_year: 2024, awarding_agency_id: 1)

      expect(mock_client).to have_received(:get).with(
        'award_spending/recipient/',
        { fiscal_year: 2024, awarding_agency_id: 1, limit: 10, page: 1 }
      )
    end
  end
end
