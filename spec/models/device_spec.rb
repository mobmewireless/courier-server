require 'spec_helper'

describe Device do
  it { should have_many(:messages) }

  context 'While creating a new device' do
    it { should validate_presence_of(:device_type) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:push_id) }

    it { should validate_uniqueness_of(:name) }
  end
end
