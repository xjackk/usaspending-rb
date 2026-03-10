# frozen_string_literal: true

RSpec.describe USAspending::Resources::SpendingExplorer do
  subject(:explorer) { USAspending.spending_explorer }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#explore' do
    it 'posts spending explorer query' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      explorer.explore(type: 'budget_function', filters: { fiscal_year: 2024 })

      expect(mock_client).to have_received(:post).with(
        'spending/',
        { type: 'budget_function', filters: { fiscal_year: 2024 } }
      )
    end
  end
end
