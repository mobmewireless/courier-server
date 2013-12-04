require 'spec_helper'
require 'timeout'
require 'daemons/push_worker'

describe PushWorker do
  include DeviceSpecHelper
  include MessageSpecHelper
  include DaemonSpecHelper

  # gcm success responses
  let(:gcm_successful) { {'multicast_id'=>'multi_cast_id', 'success'=>1, 'failure'=>0, 'canonical_ids'=>0, 'results'=>[{'message_id'=>'1:0408' }]} }
  let(:gcm_id_changed) { {'multicast_id'=>'multi_cast_id', 'success'=>1, 'failure'=>0, 'canonical_ids'=>1, 'results'=>[{'message_id'=>'1:0408', 'registration_id'=> 'B232' }]} }

  # gcm error responses
  let(:gcm_not_registered) { {'multicast_id'=>'multi_cast_id', 'success'=>0, 'failure'=>1, 'canonical_ids'=>0, 'results'=>[{'error'=>'NotRegistered'}]} } # app uninstalled.
  let(:gcm_not_available) { {'multicast_id'=>'multi_cast_id', 'success'=>0, 'failure'=>1, 'canonical_ids'=>0, 'results'=>[{'error'=>'Unavailable'}]} } # retry

  before do
    # create a valid device.
    Device.create valid_device_attributes
    # create a valid hi_gcm client.
    subject.stub(:hi_gcm_send).and_return gcm_successful
  end

  it 'should return a valid gcm_api_key while loading settings' do
    subject.settings.should have_key('gcm_api_key')
    subject.settings['gcm_api_key'].should_not be_nil
  end

  context 'when run' do
    it 'should push all the messages.' do
      target_device = Device.last
      2.times { target_device.messages.create valid_message_attributes }

      subject.should_receive(:gcm_push).exactly(2).times
      start_daemon_for_x_sec subject, 1
    end
  end

  context 'when sending messages using HiGCM' do
    before do
      Device.last.messages.create valid_message_attributes
    end

    it 'should receive hi_gcm#send' do
      reg_id = [Device.last.push_id]
      message = Message.first
      valid_message = { :data => {:mesg => message.content} }

      subject.should_receive(:hi_gcm_send).with(reg_id, valid_message)
      subject.gcm_push(message)
    end

    it 'should update the meta field with response got from gcm' do
      message = Message.first
      subject.gcm_push message

      message.reload
      message.meta.should == gcm_successful.to_json
    end

    context 'When gcm server responds' do
      context 'with success' do
        it 'should update status as successful' do
          subject.stub(:hi_gcm_send).and_return gcm_successful

          message = Message.first
          subject.gcm_push message

          message.reload
          message.status.should == Message::STATES[:success]
        end

        it 'should update the device push_id if response has a canonical id' do
          subject.stub(:hi_gcm_send).and_return gcm_id_changed

          message = Message.first
          subject.gcm_push message

          Device.first.push_id.should == 'B232'
        end
      end

      context 'with error' do
        it 'should mark status as pending in case not available' do # retry event
          subject.stub(:hi_gcm_send).and_return gcm_not_available

          message = Message.first
          subject.gcm_push message

          message.reload
          message.status.should == Message::STATES[:pending]
        end

        it 'should mark status as failed in case not registered' do  # uninstalled event
          subject.stub(:hi_gcm_send).and_return gcm_not_registered

          message = Message.first
          subject.gcm_push message

          message.reload
          message.status.should == Message::STATES[:fail]
        end
      end
    end
  end
end