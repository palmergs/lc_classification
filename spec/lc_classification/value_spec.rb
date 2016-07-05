require 'spec_helper'

RSpec.describe LcClassification::Value, as: :model do

  describe '#from_string' do
    describe '#lo values' do
      it 'can parse simple values from string' do
        val = LcClassification::Value.lo_value('123')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(0)
        expect(val.exclude).to be_falsey
      end

      it 'can parse values from string' do
        val = LcClassification::Value.lo_value('123.456')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(456)
        expect(val.exclude).to be_falsey
      end

      it 'can parse a simple excluded value' do
        val = LcClassification::Value.lo_value('(123)')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(1)
        expect(val.exclude).to be_truthy
      end

      it 'can parse a excluded value' do
        val = LcClassification::Value.lo_value('(123.456)')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(457)
        expect(val.exclude).to be_truthy
      end
    end

    describe '#hi_value' do
      it 'can parse simple values from string' do
        val = LcClassification::Value.hi_value('123')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(0)
        expect(val.exclude).to be_falsey
      end

      it 'can parse values from string' do
        val = LcClassification::Value.hi_value('123.456')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(456)
        expect(val.exclude).to be_falsey
      end

      it 'can parse a simple excluded value' do
        val = LcClassification::Value.hi_value('(123)')
        expect(val.value).to eq(122)
        expect(val.subvalue).to eq(999_999)
        expect(val.exclude).to be_truthy
      end

      it 'can parse a excluded value' do
        val = LcClassification::Value.hi_value('(123.456)')
        expect(val.value).to eq(123)
        expect(val.subvalue).to eq(455)
        expect(val.exclude).to be_truthy
      end
    end
  end

  describe '#initialize' do
    it 'can be instantiated with a single value' do
      v = LcClassification::Value.new(10)
      expect(v.value).to eq(10)
      expect(v.subvalue).to eq(0)
      expect(v.exclude).to be_falsey
      expect(v.to_s).to eq("10")
    end

    it 'can be instantiated with as an exclusive range' do
      v = LcClassification::Value.new(10, exclude: :lo)
      expect(v.value).to eq(10)
      expect(v.subvalue).to eq(1)
      expect(v.exclude).to be_truthy
      expect(v.to_s).to eq("(10)")
    end

    it 'can be instantiated with a subvalue' do
      v = LcClassification::Value.new(10, subvalue: 123)
      expect(v.value).to eq(10)
      expect(v.subvalue).to eq(123)
      expect(v.exclude).to be_falsey
      expect(v.to_s).to eq("10.123")
    end

    it 'can be instantiated with subvalue and exclusive range' do
      v = LcClassification::Value.new(10, subvalue: 123, exclude: :lo)
      expect(v.value).to eq(10)
      expect(v.subvalue).to eq(124)
      expect(v.exclude).to be_truthy
      expect(v.to_s).to eq("(10.123)")
    end
  end

  describe '#comprable' do
    it 'can compare values' do
      v1 = LcClassification::Value.new(10)
      v2 = LcClassification::Value.new(10, subvalue: 1)
      v3 = LcClassification::Value.new(9, subvalue: 999)

      expect(v1).to eq(v1)
      expect(v2).to eq(v2)
      expect(v3).to eq(v3)

      expect(v1).to be < v2
      expect(v1).to be > v3
      expect(v1).to be <= v2
      expect(v1).to be >= v3

      expect(v1).to_not eq(v2)
      expect(v1).to_not eq(v3)

      expect(v1).to be_in(v3, v2)
      expect(v2).to_not be_in(v3, v1)
      expect(v3).to_not be_in(v1, v2)
    end
  end
end
