require 'serverspec'
require 'pathname'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'Ruby installation' do
  let(:destination) { Pathname.new('/opt/ruby') }

  it 'unpacks Ruby build at destination directory' do
    expect(file(destination)).to                  be_directory
    expect(file(destination.join('bin/ruby'))).to be_file
    expect(file(destination.join('bin/gem'))).to  be_file
  end

  it 'installs desired ruby version' do
    expect(command(destination.join('bin/ruby -v'))).to return_stdout(/2.1.2/)
  end

end
