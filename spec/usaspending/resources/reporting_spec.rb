# frozen_string_literal: true

RSpec.describe USAspending::Resources::Reporting do
  subject(:reporting) { USAspending.reporting }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#agencies_overview' do
    it 'gets agencies overview' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      reporting.agencies_overview(fiscal_year: 2024, fiscal_period: 6)

      expect(mock_client).to have_received(:get).with(
        'reporting/agencies/overview/',
        hash_including(fiscal_year: 2024, fiscal_period: 6)
      )
    end
  end

  describe '#differences' do
    it 'gets account differences for an agency' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      reporting.differences('020', fiscal_year: 2024, fiscal_period: 6)

      expect(mock_client).to have_received(:get).with(
        'reporting/agencies/020/differences/',
        hash_including(fiscal_year: 2024)
      )
    end
  end

  describe '#submission_history' do
    it 'gets submission history' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      reporting.submission_history('020', fiscal_year: 2024, fiscal_period: 6)

      expect(mock_client).to have_received(:get).with('reporting/agencies/020/2024/6/submission_history/', {})
    end
  end

  describe '#unlinked_awards' do
    it 'gets unlinked awards' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      reporting.unlinked_awards('020', fiscal_year: 2024, fiscal_period: 6, type: 'assistance')

      expect(mock_client).to have_received(:get).with('reporting/agencies/020/2024/6/unlinked_awards/assistance/', {})
    end
  end
end
