# frozen_string_literal: true

RSpec.describe USAspending::Client do
  subject(:client) { described_class.new }

  describe '#get' do
    it 'raises ConnectionError on timeout' do
      allow_any_instance_of(Faraday::Connection) # rubocop:disable RSpec/AnyInstance
        .to receive(:get)
        .and_raise(Faraday::TimeoutError)

      expect { client.get('some/path/') }.to raise_error(USAspending::ConnectionError)
    end

    it 'raises ConnectionError on connection failure' do
      allow_any_instance_of(Faraday::Connection) # rubocop:disable RSpec/AnyInstance
        .to receive(:get)
        .and_raise(Faraday::ConnectionFailed, 'refused')

      expect { client.get('some/path/') }.to raise_error(USAspending::ConnectionError)
    end
  end

  describe '#post' do
    it 'raises ConnectionError on timeout' do
      allow_any_instance_of(Faraday::Connection) # rubocop:disable RSpec/AnyInstance
        .to receive(:post)
        .and_raise(Faraday::TimeoutError)

      expect { client.post('some/path/') }.to raise_error(USAspending::ConnectionError)
    end
  end

  describe '#connection' do
    it 'returns a Faraday::Connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end

    it 'uses the configured base_url' do
      USAspending.configure { |c| c.base_url = 'https://example.com/' }
      custom_client = described_class.new
      expect(custom_client.connection.url_prefix.to_s).to eq('https://example.com/')
    end
  end

  describe 'resource accessors' do
    it 'returns memoized resource instances' do
      expect(client.awards).to be_a(USAspending::Resources::Awards)
      expect(client.awards).to equal(client.awards) # same object
    end

    it 'provides all resource accessors' do
      %i[awards agency spending recipient autocomplete references disaster
         search federal_accounts download bulk_download idv subawards
         transactions spending_explorer reporting federal_obligations
         financial_balances financial_spending budget_functions award_spending].each do |name|
        expect(client).to respond_to(name)
      end
    end
  end

  describe '#inspect' do
    it 'returns a concise string' do
      expect(client.inspect).to include('base_url=')
      expect(client.inspect).to include('timeout=')
    end
  end
end
