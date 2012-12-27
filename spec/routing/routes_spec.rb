require 'spec_helper'


describe 'routes' do
  context "robokassa" do
    specify { get('/robokassa/notify/some-secure-notification-key').should route_to(
      controller:       'robokassa',
      action:           'notify',
      token:            'some-secure-notification-key'
    )}

    specify { get('/robokassa/success').should route_to(
      controller: 'robokassa',
      action:     'success'
    )}

    specify { get('/robokassa/fail').should route_to(
      controller: 'robokassa',
      action:     'fail'
    )}
  end
end

