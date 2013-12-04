require 'spec_helper'

describe DevicesController do

  include DeviceSpecHelper

  # POST /device
  context 'when creating a device' do
    it 'should add a new device' do
      expect { post :create, valid_device_attributes }.to change(Device, :count).by(1)
    end

    it 'should set the device attributes correctly.' do
      post :create, valid_device_attributes
      device = Device.last
      # nil check
      device.should_not be_nil
      # checking params
      device.name.should == valid_device_attributes[:name]
      device.device_type.should == valid_device_attributes[:device_type]
      device.push_id.should == valid_device_attributes[:push_id]
    end

    context 'if device already exists' do
      before :all do
        Device.create valid_device_attributes
      end

      it 'should not add a new record' do
        # record with existing name 'test_1'
        expect {  post :create,  valid_device_attributes.with({push_id: 'B234', device_type: 'iphone'}) }.to_not change(Device, :count).by(1)
      end

      it "should update the existing device's attributes" do
        # record with existing name 'test_1'
        post :create,  valid_device_attributes.with({push_id: 'B234', device_type: 'iphone'})
        device = Device.last
        # nil check
        device.should_not be_nil
        # checking params
        device.name.should == valid_device_attributes[:name]
        device.device_type.should == 'iphone'
        device.push_id.should == 'B234'
      end
    end

    it 'should return a success response given valid params' do
      post :create, valid_device_attributes
      response.body.should == {status: 'success'}.to_json
    end
  end
end