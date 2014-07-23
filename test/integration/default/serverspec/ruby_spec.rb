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

  it 'installs desired Ruby version' do
    expect(command(destination.join('bin/ruby -v'))).to return_stdout(/2.1.2/)
  end

  it 'installs desired Rubygems version' do
    expect(command(%Q/PATH=#{destination.join('bin')} #{destination.join('bin/gem -v')}/)).to return_stdout(/2.4.1/)
  end

  it 'installs required libyaml dependency' do
    expect(package('libyaml-0-2')).to be_installed
  end

end
