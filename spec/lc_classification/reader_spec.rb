require 'spec_helper'

RSpec.describe LcClassification::Reader, as: :model do

  describe '#regex' do
    it 'matches simple entries' do
      match = LcClassification::Reader::REGEX.match("AC999   Scrapbooks")
      expect(match[1]).to eq('AC')
      expect(match[2]).to eq('999')
      expect(match[6]).to eq('Scrapbooks')
    end

    it 'matches ranges' do
      match = LcClassification::Reader::REGEX.match("BJ1298-1335   Evolutionary and genetic ethics")
      expect(match[1]).to eq('BJ')
      expect(match[2]).to eq('1298')
      expect(match[4]).to eq('1335')
      expect(match[6]).to eq('Evolutionary and genetic ethics')
    end

    it 'matches ranges with subvalue' do
      match = LcClassification::Reader::REGEX.match("BL1109.2-1109.7         Antiquities.  Archaeology.  Inscriptions")
      expect(match[1]).to eq('BL')
      expect(match[2]).to eq('1109.2')
      expect(match[4]).to eq('1109.7')
      expect(match[6]).to eq('Antiquities.  Archaeology.  Inscriptions')
    end

    it 'matches ranges with exclusions' do
      match = LcClassification::Reader::REGEX.match("D(204)-(475)    Modern history, 1453-")
      expect(match[1]).to eq('D')
      expect(match[2]).to eq('(204)')
      expect(match[4]).to eq('(475)')
      expect(match[6]).to eq('Modern history, 1453-')
    end
  end

  it 'can read a file and pass nodes to block' do
    reader = LcClassification::Reader.new('spec/samples/test.txt')
  end
end
