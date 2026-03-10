# frozen_string_literal: true

RSpec.describe USAspending::Resources::Agency do
  subject(:agency) { USAspending.agency }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#overview' do
    it 'gets agency overview' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'name' => 'Treasury' }, 200))

      response = agency.overview('020')

      expect(mock_client).to have_received(:get).with('agency/020/', {})
      expect(response['name']).to eq('Treasury')
    end

    it 'passes fiscal_year when provided' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      agency.overview('020', fiscal_year: 2024)

      expect(mock_client).to have_received(:get).with('agency/020/', { fiscal_year: 2024 })
    end
  end

  describe '#awards' do
    it 'gets awards summary' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      agency.awards('020')

      expect(mock_client).to have_received(:get).with('agency/020/awards/', {})
    end
  end

  describe '#new_awards_count' do
    it 'gets new awards count' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'count' => 5 }, 200))

      agency.new_awards_count('020', fiscal_year: 2024)

      expect(mock_client).to have_received(:get).with('agency/020/awards/new/count/', { fiscal_year: 2024 })
    end
  end

  describe '#budgetary_resources' do
    it 'gets budgetary resources' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      agency.budgetary_resources('020')

      expect(mock_client).to have_received(:get).with('agency/020/budgetary_resources/', {})
    end
  end

  describe '#object_class' do
    it 'gets object classes' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      agency.object_class('020', fiscal_year: 2024)

      expect(mock_client).to have_received(:get).with('agency/020/object_class/', hash_including(fiscal_year: 2024))
    end
  end

  describe '#program_activity' do
    it 'gets program activities' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      agency.program_activity('020')

      expect(mock_client).to have_received(:get).with('agency/020/program_activity/', hash_including(limit: 10))
    end
  end

  describe '#sub_agencies' do
    it 'gets sub-agencies' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      agency.sub_agencies('097', limit: 25, page: 2)

      expect(mock_client).to have_received(:get).with('agency/097/sub_agency/', { limit: 25, page: 2 })
    end
  end

  describe '#sub_components' do
    it 'gets bureaus' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      agency.sub_components('097')

      expect(mock_client).to have_received(:get).with('agency/097/sub_components/', hash_including(limit: 10))
    end
  end

  describe '#treasury_account_object_class' do
    it 'gets TAS object classes' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      agency.treasury_account_object_class('020-0101')

      expect(mock_client).to have_received(:get).with('agency/treasury_account/020-0101/object_class/',
                                                      hash_including(limit: 10))
    end
  end

  describe '#list' do
    it 'gets all top-tier agencies' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      agency.list

      expect(mock_client).to have_received(:get).with('references/toptier_agencies/', {})
    end
  end
end
