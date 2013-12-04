require 'spec_helper'

describe 'Routing to devices' do
  it 'routes /devices(post) to devices#create' do
    expect(:post => '/devices').to route_to(
      :controller => 'devices',
      :action => 'create',
    )
  end

  it 'does not expose a list of devices' do
    expect(:get => '/devices').not_to be_routable
  end

  # This should be enabled ?
  it 'does not expose a delete device route' do
    expect(:delete => '/devices/1').not_to be_routable
  end

  it 'routes /devices/:name/push to Messages for name' do
    expect(:post => '/devices/device_1/messages').to route_to(
       :controller => 'messages',
       :action => 'create',
       :device_id => 'device_1'
   )
  end
end