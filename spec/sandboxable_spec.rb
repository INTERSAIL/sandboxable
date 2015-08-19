require 'spec_helper'

describe Sandboxable do
  it 'has a version number' do
    expect(Sandboxable::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
