# frozen_string_literal: true

RSpec.describe USAspending::Error do
  it 'is a StandardError' do
    expect(described_class.ancestors).to include(StandardError)
  end
end

RSpec.describe USAspending::ClientError do
  subject(:error) { described_class.new(status: 400, body: { 'detail' => 'bad request' }) }

  it 'exposes status and body' do
    expect(error.status).to eq(400)
    expect(error.body).to eq({ 'detail' => 'bad request' })
  end

  it 'generates a sensible message' do
    expect(error.message).to match(/400/)
  end
end

RSpec.describe USAspending::NotFoundError do
  it 'inherits from ClientError' do
    expect(described_class.ancestors).to include(USAspending::ClientError)
  end
end

RSpec.describe USAspending::RateLimitError do
  it 'inherits from ClientError' do
    expect(described_class.ancestors).to include(USAspending::ClientError)
  end
end

RSpec.describe USAspending::ServerError do
  subject(:error) { described_class.new(status: 503, body: 'Service Unavailable') }

  it 'exposes status' do
    expect(error.status).to eq(503)
  end
end

RSpec.describe USAspending::ConnectionError do
  it 'inherits from USAspending::Error' do
    expect(described_class.ancestors).to include(USAspending::Error)
  end
end
