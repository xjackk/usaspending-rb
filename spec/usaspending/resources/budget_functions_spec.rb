# frozen_string_literal: true

RSpec.describe USAspending::Resources::BudgetFunctions do
  subject(:budget_fns) { USAspending.budget_functions }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#list' do
    it 'gets all budget functions' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      budget_fns.list

      expect(mock_client).to have_received(:get).with('budget_functions/list_budget_functions/', {})
    end
  end

  describe '#subfunctions' do
    it 'posts subfunctions for a budget function' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      budget_fns.subfunctions(budget_function: '050')

      expect(mock_client).to have_received(:post).with(
        'budget_functions/list_budget_subfunctions/',
        { budget_function: '050' }
      )
    end
  end
end
