require 'spec_helper'

describe Message do
  context 'while creating a new message' do
    it { should belong_to(:device) }

    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:device_id) }

  end

end
