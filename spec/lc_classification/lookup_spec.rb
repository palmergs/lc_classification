require 'spec_helper'

RSpec.describe LcClassification::Lookup, as: :model do
  it 'can be instantiated with a file path' do
    lookup = LcClassification::Lookup.new('spec/samples/test.txt')  
    expect(lookup.find('AC1').description).to eq('American and English')
    expect(lookup.find('AC999').description).to eq('Scrapbooks')
    expect(lookup.find('AC9').description).to eq('Other languages')
    expect(lookup.find('AC195').description).to eq('Other languages')
    expect(lookup.find('AC200').description).to eq('Collections for Jewish readers')
    expect(lookup.find('AC998').description).to eq('Collections.  Series.  Collected works')
  end
end
