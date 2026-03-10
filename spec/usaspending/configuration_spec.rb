# frozen_string_literal: true

RSpec.describe USAspending::Configuration do
  subject(:config) { described_class.new }

  describe 'defaults' do
    it { expect(config.base_url).to eq('https://api.usaspending.gov/api/v2/') }
    it { expect(config.timeout).to eq(30) }
    it { expect(config.retries).to eq(3) }
    it { expect(config.logger).to be_nil }
  end

  describe 'configure block' do
    before do
      USAspending.configure do |c|
        c.timeout = 10
        c.retries = 1
        c.base_url = 'https://example.com/'
      end
    end

    it 'applies configuration' do
      expect(USAspending.configuration.timeout).to eq(10)
      expect(USAspending.configuration.retries).to eq(1)
      expect(USAspending.configuration.base_url).to eq('https://example.com/')
    end
  end

  describe '.reset!' do
    it 'restores default configuration' do
      USAspending.configure { |c| c.timeout = 1 }
      USAspending.reset!
      expect(USAspending.configuration.timeout).to eq(30)
    end
  end

  describe '#to_h' do
    it 'returns all settings as a hash' do
      h = config.to_h
      expect(h[:base_url]).to eq('https://api.usaspending.gov/api/v2/')
      expect(h[:timeout]).to eq(30)
      expect(h[:retries]).to eq(3)
      expect(h).to have_key(:logger)
      expect(h).to have_key(:adapter)
    end
  end

  describe '#inspect' do
    it 'returns a concise string' do
      expect(config.inspect).to include('base_url=')
      expect(config.inspect).to include('timeout=30')
      expect(config.inspect).to include('retries=3')
    end
  end
end
