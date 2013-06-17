require 'fakeweb'

def stub_file(stub)
  File.join(File.dirname(__FILE__), 'stubs', stub)
end

def fake_it_all
  FakeWeb.clean_registry
  FakeWeb.register_uri :head, %r{http://(my.|f.)?cl.ly(/items)?}, :status => ["200", "OK"]
  FakeWeb.register_uri :post, 'http://f.cl.ly', :status => ["303"], :location => "http://my.cl.ly/items/s3"
  FakeWeb.register_uri :post, 'http://my.cl.ly/reset', :status => ["200", "OK"]
  {
    # GET URLs
    :get => {
      %r{http://cl.ly/\w+}                => File.join('drop', 'show'),
      'http://my.cl.ly/items'             => File.join('drop', 'index'),
      'http://my.cl.ly/items/new'         => File.join('drop', 'new'),
      'http://my.cl.ly/items/new?item[private]=true' => File.join('drop', 'new-private'),
      'http://my.cl.ly/items/s3'          => File.join('drop', 'show'),
      'http://my.cl.ly/items/s3?item[private]=true' => File.join('drop', 'show-private'),
      'http://my.cl.ly/account'           => File.join('account', 'show'),
      'http://my.cl.ly/account/stats'     => File.join('account', 'stats'),
      %r{http://my.cl.ly/gift_cards/\w+}  => File.join('gift_card', 'show')
    },
    # POST URLs
    :post => {
      'http://my.cl.ly/items'             => File.join('drop', 'create'),
      'http://my.cl.ly/register'          => File.join('account', 'create')
    },
    # PUT URLs
    :put => {
      %r{http://my.cl.ly/items/\d+}       => File.join('drop', 'update'),
      'http://my.cl.ly/account'           => File.join('account', 'update'),
      %r{http://my.cl.ly/gift_cards/\w+}  => File.join('gift_card', 'redeem')
    },
    # DELETE URLs
    :delete => {
      %r{http://my.cl.ly/items/\d+}       => File.join('drop', 'delete')
    }
  }.
  each do |method, requests|
    requests.each do |url, response|
      FakeWeb.register_uri(method, url, :response => stub_file(response))
    end
  end
end

def fake_it_all_with_errors
  FakeWeb.clean_registry
  FakeWeb.register_uri :head, %r{http://(my.|f.)?cl.ly(/items)?}, :status => ["200", "OK"]
  {
    :get => {
      'http://my.cl.ly/items'             => File.join('error', '401'),
      %r{http://cl.ly/\w+}                => File.join('error', '404-find'),
      'http://my.cl.ly/items/new'         => File.join('drop', 'new')
    },
    :put => {
      %r{http://my.cl.ly/items/\d+}       => File.join('error', '404-update')
    }
  }.each do |method, requests|
    requests.each do |url, response|
      FakeWeb.register_uri(method, url, :response => stub_file(response))
    end
  end
end
