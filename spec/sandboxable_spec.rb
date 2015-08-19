require 'spec_helper'

describe Sandboxable do
  it 'has a version number' do
    expect(Sandboxable::VERSION).not_to be nil
  end
end
