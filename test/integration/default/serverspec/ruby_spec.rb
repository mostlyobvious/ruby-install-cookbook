require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/home/vagrant/ruby-2.1.2/bin'
  end
end

describe "Ruby installation" do

  it "it has a ruby binary" do
    expect(command('ruby -v')).to return_exit_status(0)
  end

end
