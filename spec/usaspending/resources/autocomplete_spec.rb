# frozen_string_literal: true

RSpec.describe USAspending::Resources::Autocomplete do
  subject(:autocomplete) { USAspending.autocomplete }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#location' do
    it 'posts location autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [{}] }, 200))

      response = autocomplete.location('22201', geo_layer: 'zip_code')

      expect(mock_client).to have_received(:post).with(
        'autocomplete/location/',
        hash_including(search_text: '22201', geo_layer: 'zip_code')
      )
      expect(response.results).not_to be_empty
    end
  end

  describe '#awarding_agency' do
    it 'posts agency autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.awarding_agency('DoD')

      expect(mock_client).to have_received(:post).with('autocomplete/awarding_agency/',
                                                       { search_text: 'DoD', limit: 10 })
    end
  end

  describe '#funding_agency' do
    it 'posts funding agency autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.funding_agency('Treasury')

      expect(mock_client).to have_received(:post).with('autocomplete/funding_agency/',
                                                       { search_text: 'Treasury', limit: 10 })
    end
  end

  describe '#recipient' do
    it 'posts recipient autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.recipient('Booz Allen', limit: 5)

      expect(mock_client).to have_received(:post).with('autocomplete/recipient/',
                                                       { search_text: 'Booz Allen', limit: 5 })
    end
  end

  describe '#naics' do
    it 'posts NAICS autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.naics('541')

      expect(mock_client).to have_received(:post).with('autocomplete/naics/', { search_text: '541', limit: 10 })
    end
  end

  describe '#psc' do
    it 'posts PSC autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.psc('R425')

      expect(mock_client).to have_received(:post).with('autocomplete/psc/', { search_text: 'R425', limit: 10 })
    end
  end

  describe '#cfda' do
    it 'posts CFDA autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.cfda('health')

      expect(mock_client).to have_received(:post).with('autocomplete/cfda/', { search_text: 'health', limit: 10 })
    end
  end

  describe '#city' do
    it 'posts city autocomplete with defaults' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.city('Arlington')

      expect(mock_client).to have_received(:post).with(
        'autocomplete/city/',
        { search_text: 'Arlington', limit: 10, filter: { country_code: 'USA', scope: 'recipient_location' } }
      )
    end

    it 'posts city autocomplete with state filter' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.city('Arlington', state_code: 'VA', scope: 'primary_place_of_performance')

      expect(mock_client).to have_received(:post).with(
        'autocomplete/city/',
        { search_text: 'Arlington', limit: 10,
          filter: { country_code: 'USA', scope: 'primary_place_of_performance', state_code: 'VA' } }
      )
    end
  end

  describe '#glossary' do
    it 'posts glossary autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.glossary('obligation')

      expect(mock_client).to have_received(:post).with('autocomplete/glossary/',
                                                       { search_text: 'obligation', limit: 10 })
    end
  end

  describe '#program_activity' do
    it 'posts program activity autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.program_activity('research')

      expect(mock_client).to have_received(:post).with('autocomplete/program_activity/',
                                                       { search_text: 'research', limit: 10 })
    end
  end

  describe '#accounts_ata' do
    it 'posts TAS ATA autocomplete' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.accounts_ata('020')

      expect(mock_client).to have_received(:post).with('autocomplete/accounts/ata/', { search_text: '020', limit: 10 })
    end
  end

  describe '#accounts_main' do
    it 'posts TAS main account autocomplete with filters' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      autocomplete.accounts_main('0101', filters: { aid: '020' })

      expect(mock_client).to have_received(:post).with(
        'autocomplete/accounts/main/',
        { search_text: '0101', limit: 10, filters: { aid: '020' } }
      )
    end
  end
end
