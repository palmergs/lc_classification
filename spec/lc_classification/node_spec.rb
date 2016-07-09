require 'spec_helper'

RSpec.describe LcClassification::Node, as: :model do

  describe '#initialize' do
    it 'takes a prefix string, min and max values, and a description' do
      node = LcClassification::Node.new('AA',
          LcClassification::Value.new(10),
          LcClassification::Value.new(20),
          "This is a test")
      expect(node.prefix).to eq('AA')
      expect(node.children).to be_empty
      expect(node.parent).to be_nil
    end
  end

  describe 'tree structure' do
    it 'can have a child that is a subset of the current range' do
      lcs = (0..5).to_a.map {|n| LcClassification::Value.new(n) }
      parent = LcClassification::Node.new('AA', lcs[1], lcs[4], 'The parent')
      child = LcClassification::Node.new('AA', lcs[1], lcs[2], 'The child')
      expect(parent.insert(child)).to eq(0) # index of the child position

      bad1 = LcClassification::Node.new('ZZ', lcs[1], lcs[2], 'Incorrect prefix')
      expect { parent.insert(bad1) }.to raise_error(RuntimeError)

      bad2 = LcClassification::Node.new('AA', lcs[2], lcs[5], 'Extends past max')
      expect { parent.insert(bad2) }.to raise_error(RuntimeError)

      bad3 = LcClassification::Node.new('AA', lcs[0], lcs[3], 'Extends past min')
      expect { parent.insert(bad3) }.to raise_error(RuntimeError)

     end
  end
end
