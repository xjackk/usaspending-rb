# frozen_string_literal: true

RSpec.describe USAspending::Resources::References do
  subject(:references) { USAspending.references }

  let(:mock_client) { instance_double(USAspending::Client) }

  before do
    allow(USAspending).to receive(:client).and_return(mock_client)
  end

  describe '#agency' do
    it 'gets agency info by ID' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      references.agency('123')

      expect(mock_client).to have_received(:get).with('references/agency/123/', {})
    end
  end

  describe '#assistance_listings' do
    it 'gets all assistance listings' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.assistance_listings

      expect(mock_client).to have_received(:get).with('references/assistance_listing/', {})
    end
  end

  describe '#award_types' do
    it 'gets award type definitions' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      references.award_types

      expect(mock_client).to have_received(:get).with('references/award_types/', {})
    end
  end

  describe '#cfda_totals' do
    it 'gets CFDA totals' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.cfda_totals

      expect(mock_client).to have_received(:get).with('references/cfda/totals/', {})
    end
  end

  describe '#cfda_total' do
    it 'gets totals for a specific CFDA' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      references.cfda_total('10.553')

      expect(mock_client).to have_received(:get).with('references/cfda/totals/10.553/', {})
    end
  end

  describe '#data_dictionary' do
    it 'gets the data dictionary' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      references.data_dictionary

      expect(mock_client).to have_received(:get).with('references/data_dictionary/', {})
    end
  end

  describe '#def_codes' do
    it 'gets DEFC codes' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.def_codes

      expect(mock_client).to have_received(:get).with('references/def_codes/', {})
    end
  end

  describe '#naics' do
    it 'gets NAICS codes' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.naics(depth: 2)

      expect(mock_client).to have_received(:get).with('references/naics/', { depth: 2 })
    end
  end

  describe '#naics_code' do
    it 'gets a specific NAICS code' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({}, 200))

      references.naics_code('541')

      expect(mock_client).to have_received(:get).with('references/naics/541/', {})
    end
  end

  describe '#psc_tree' do
    it 'gets top-level PSC groups' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.psc_tree

      expect(mock_client).to have_received(:get).with('references/filter_tree/psc/', {})
    end

    it 'gets PSC tier 1 children' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.psc_tree('A')

      expect(mock_client).to have_received(:get).with('references/filter_tree/psc/A/', {})
    end
  end

  describe '#tas_tree' do
    it 'gets TAS agencies' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.tas_tree

      expect(mock_client).to have_received(:get).with('references/filter_tree/tas/', {})
    end
  end

  describe '#glossary' do
    it 'gets glossary terms with pagination' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.glossary(limit: 25, page: 2)

      expect(mock_client).to have_received(:get).with('references/glossary/', { limit: 25, page: 2 })
    end
  end

  describe '#toptier_agencies' do
    it 'gets all toptier agencies' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.toptier_agencies

      expect(mock_client).to have_received(:get).with('references/toptier_agencies/', {})
    end
  end

  describe '#submission_periods' do
    it 'gets submission periods' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.submission_periods

      expect(mock_client).to have_received(:get).with('references/submission_periods/', {})
    end
  end

  describe '#total_budgetary_resources' do
    it 'gets total budgetary resources' do
      allow(mock_client).to receive(:get).and_return(USAspending::Response.new({ 'results' => [] }, 200))

      references.total_budgetary_resources

      expect(mock_client).to have_received(:get).with('references/total_budgetary_resources/', {})
    end
  end

  describe '#filter' do
    it 'posts filter hash generation' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'hash' => 'abc123' }, 200))

      references.filter({ fiscal_years: [2024] })

      expect(mock_client).to have_received(:post).with('references/filter/', { fiscal_years: [2024] })
    end
  end

  describe '#hash_filter' do
    it 'retrieves filter from hash' do
      allow(mock_client).to receive(:post).and_return(USAspending::Response.new({ 'filter' => {} }, 200))

      references.hash_filter('abc123')

      expect(mock_client).to have_received(:post).with('references/hash/', { hash: 'abc123' })
    end
  end
end
