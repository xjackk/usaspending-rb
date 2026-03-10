# frozen_string_literal: true

RSpec.describe USAspending::Response do
  describe '#results' do
    it "returns 'results' key when present" do
      response = described_class.new({ 'results' => [{ 'id' => 1 }] }, 200)
      expect(response.results).to eq([{ 'id' => 1 }])
    end

    it "falls back to 'data' key" do
      response = described_class.new({ 'data' => [{ 'id' => 2 }] }, 200)
      expect(response.results).to eq([{ 'id' => 2 }])
    end

    it 'returns empty array when neither key exists' do
      response = described_class.new({ 'count' => 0 }, 200)
      expect(response.results).to eq([])
    end

    it 'returns the raw array when body is an Array (e.g. recipient/state/)' do
      body = [{ 'fips' => '51', 'name' => 'Virginia' }]
      response = described_class.new(body, 200)
      expect(response.results).to eq(body)
    end

    it "falls back to first Array value for non-standard keys (e.g. 'codes')" do
      body = { 'codes' => [{ 'code' => 'L', 'title' => 'COVID-19' }] }
      response = described_class.new(body, 200)
      expect(response.results).to eq([{ 'code' => 'L', 'title' => 'COVID-19' }])
    end

    it "falls back to first Array value for 'available_periods'" do
      body = { 'available_periods' => [{ 'fiscal_year' => 2024, 'fiscal_month' => 12 }] }
      response = described_class.new(body, 200)
      expect(response.results).to eq([{ 'fiscal_year' => 2024, 'fiscal_month' => 12 }])
    end
  end

  describe '#total_count' do
    it 'reads from page_metadata.count' do
      response = described_class.new({ 'page_metadata' => { 'count' => 42 } }, 200)
      expect(response.total_count).to eq(42)
    end

    it 'reads from page_metadata.total' do
      response = described_class.new({ 'page_metadata' => { 'total' => 99 } }, 200)
      expect(response.total_count).to eq(99)
    end

    it 'falls back to top-level count' do
      response = described_class.new({ 'count' => 7 }, 200)
      expect(response.total_count).to eq(7)
    end
  end

  describe '#has_next_page?' do
    it 'returns true when hasNext is true' do
      response = described_class.new({ 'page_metadata' => { 'hasNext' => true } }, 200)
      expect(response.has_next_page?).to be true
    end

    it 'returns false when hasNext is false' do
      response = described_class.new({ 'page_metadata' => { 'hasNext' => false } }, 200)
      expect(response.has_next_page?).to be false
    end

    it 'returns false when page_metadata is missing' do
      response = described_class.new({}, 200)
      expect(response.has_next_page?).to be false
    end
  end

  describe '#[]' do
    it 'delegates to raw hash' do
      response = described_class.new({ 'count' => 5 }, 200)
      expect(response['count']).to eq(5)
    end

    it 'returns nil when raw is an Array' do
      response = described_class.new([{ 'id' => 1 }], 200)
      expect(response['id']).to be_nil
    end
  end

  describe '#to_h' do
    it 'returns the raw body' do
      body = { 'results' => [] }
      response = described_class.new(body, 200)
      expect(response.to_h).to eq(body)
    end

    it 'wraps an Array body as a Hash' do
      body = [{ 'fips' => '51' }]
      response = described_class.new(body, 200)
      expect(response.to_h).to eq({ 'results' => body })
    end
  end

  describe '#each' do
    it 'yields each result' do
      response = described_class.new({ 'results' => [{ 'a' => 1 }, { 'a' => 2 }] }, 200)
      values = response.map { |r| r['a'] }
      expect(values).to eq([1, 2])
    end
  end

  describe '#size / #length' do
    it 'returns the number of results' do
      response = described_class.new({ 'results' => [1, 2, 3] }, 200)
      expect(response.size).to eq(3)
      expect(response.length).to eq(3)
    end
  end

  describe '#empty?' do
    it 'returns true when no results' do
      response = described_class.new({ 'results' => [] }, 200)
      expect(response.empty?).to be true
    end

    it 'returns false when results exist' do
      response = described_class.new({ 'results' => [1] }, 200)
      expect(response.empty?).to be false
    end
  end

  describe '#dig' do
    it 'digs into nested hash' do
      response = described_class.new({ 'page_metadata' => { 'count' => 42 } }, 200)
      expect(response.dig('page_metadata', 'count')).to eq(42)
    end
  end

  describe '#last_record_unique_id' do
    it 'reads from page_metadata' do
      response = described_class.new({ 'page_metadata' => { 'last_record_unique_id' => 99 } }, 200)
      expect(response.last_record_unique_id).to eq(99)
    end
  end

  describe '#last_page' do
    it 'reads from page_metadata' do
      response = described_class.new({ 'page_metadata' => { 'last_page' => 5 } }, 200)
      expect(response.last_page).to eq(5)
    end
  end

  describe '#to_json' do
    it 'serializes to JSON string' do
      response = described_class.new({ 'count' => 1 }, 200)
      expect(JSON.parse(response.to_json)).to eq({ 'count' => 1 })
    end
  end

  describe '#success?' do
    it 'returns true for 2xx' do
      expect(described_class.new({}, 200).success?).to be true
      expect(described_class.new({}, 201).success?).to be true
    end

    it 'returns false for non-2xx' do
      expect(described_class.new({}, 404).success?).to be false
    end
  end

  describe '#inspect' do
    it 'returns a concise string' do
      response = described_class.new({ 'results' => [1], 'page_metadata' => { 'hasNext' => true } }, 200)
      expect(response.inspect).to include('status=200')
      expect(response.inspect).to include('size=1')
      expect(response.inspect).to include('next_page?=true')
    end
  end

  context 'when raw body is an Array' do
    let(:response) { described_class.new([{ 'name' => 'Virginia' }], 200) }

    it 'returns nil for total_count' do
      expect(response.total_count).to be_nil
    end

    it 'returns false for has_next_page?' do
      expect(response.has_next_page?).to be false
    end

    it 'returns nil for last_record_unique_id' do
      expect(response.last_record_unique_id).to be_nil
    end

    it 'returns nil for last_page' do
      expect(response.last_page).to be_nil
    end
  end
end
