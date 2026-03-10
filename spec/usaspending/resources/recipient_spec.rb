# frozen_string_literal: true

RSpec.describe USAspending::Resources::Recipient do
  subject(:recipient) { USAspending.recipient }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#find' do
    it 'gets a recipient profile by hash' do
      response_body = { 'name' => 'Booz Allen Hamilton' }
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new(response_body, 200))

      response = recipient.find('some-uuid-here')

      expect(mock_client).to have_received(:get).with('recipient/some-uuid-here/', { year: 'latest' })
      expect(response['name']).to eq('Booz Allen Hamilton')
    end
  end

  describe '#search' do
    it 'posts recipient search' do
      response_body = { 'results' => [{ 'name' => 'Booz Allen' }] }
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new(response_body, 200))

      response = recipient.search('Booz Allen', limit: 5)

      expect(mock_client).to have_received(:post).with('recipient/', hash_including(keyword: 'Booz Allen', limit: 5))
      expect(response.results).to be_an(Array)
    end
  end

  describe '#count' do
    it 'posts recipient count' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'count' => 42 }, 200))

      recipient.count({ keyword: 'test' })

      expect(mock_client).to have_received(:post).with('recipient/count/', { keyword: 'test' })
    end
  end

  describe '#children' do
    it 'gets child entities by DUNS/UEI' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      recipient.children('EY8GQLSPZJ74', year: '2024')

      expect(mock_client).to have_received(:get).with('recipient/children/EY8GQLSPZJ74/', { year: '2024' })
    end
  end

  describe '#states' do
    it 'gets all states' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      recipient.states

      expect(mock_client).to have_received(:get).with('recipient/state/', {})
    end
  end

  describe '#state' do
    it 'gets state info by FIPS' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'name' => 'Virginia' }, 200))

      recipient.state('51')

      expect(mock_client).to have_received(:get).with('recipient/state/51/', { year: 'latest' })
    end
  end

  describe '#state_awards' do
    it 'gets state award breakdown by FIPS' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      recipient.state_awards('51')

      expect(mock_client).to have_received(:get).with('recipient/state/awards/51/', { year: 'latest' })
    end
  end
end
