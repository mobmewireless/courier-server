require 'spec_helper'

describe MessagesController do

  include DeviceSpecHelper, MessageSpecHelper

  context 'when creating a message' do
    before do
      Device.create valid_device_attributes
    end

    context 'with no or invalid device name' do
      it 'should render device not found' do
        post :create, :device_id=>'invalid_device_name'
        response.body.should == { status: 'failure', errors: 'unable to find device'}.to_json
      end
    end

    context 'with a valid device name' do
      it 'should add a new message' do
        expect do
          post :create, { device_id: 'test_1', message: valid_message_attributes[:content] }
        end.to change(Message, :count).by(1)
      end

      it 'should create a new message for the device' do
        post :create, { device_id: 'test_1', message: valid_message_attributes[:content] }

        first_message = Message.first
        first_message.should_not be_nil # nil check
        first_message.should == Device.last.messages.first
      end

      it 'should save the message attributes correctly' do
        post :create, { device_id: 'test_1', message: valid_message_attributes[:content] }

        first_message = Message.first
        first_message.content.should ==  valid_message_attributes[:content]
        first_message.status.should == valid_message_attributes[:status]
      end

      it 'should return a success response' do
        post :create, { device_id: 'test_1', message: valid_message_attributes[:content] }
        response.body.should == {status: 'success'}.to_json
      end
    end
  end
end