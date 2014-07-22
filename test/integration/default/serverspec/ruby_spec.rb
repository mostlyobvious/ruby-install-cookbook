require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'Ruby installation' do
  let(:destination) { '/opt/ruby' }

  it 'unpacks Ruby build at destination directory' do
    expect(file(destination)).to be_directory
  end

end
