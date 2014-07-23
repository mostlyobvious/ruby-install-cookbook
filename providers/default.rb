action :create do
  install_ruby
  install_ruby_dependencies
  install_rubygems
end

def install_ruby
  cache_dir            = Chef::Config[:file_cache_path]
  archive_name         = "ruby-#{ruby_version}.tar.bz2"
  ruby_dir             = ::File.join(cache_dir, "ruby-#{ruby_version}")
  download_destination = ::File.join(cache_dir, archive_name)

  remote_file download_destination do
    source download_source
    mode   "0644"
    action :create_if_missing
  end

  execute "Extract Ruby archive" do
    command "tar jxvf #{download_destination} -C #{cache_dir}"
    creates ruby_dir
  end

  execute "Copy Ruby to destination" do
    command "cp -r #{ruby_dir} #{destination_dir}"
    creates destination_dir
  end
end

def install_ruby_dependencies
  package "libyaml-0-2"
end

def install_rubygems
  execute "Install Rubygems" do
    command     "gem update --system #{rubygems_version}"
    environment "PATH"     => bin_dir,
                "GEM_HOME" => `#{ruby_bin} -e "print Gem.paths.home"`

    not_if { `#{ruby_bin} -e "print Gem::VERSION"` == rubygems_version }
  end
end

def download_source
  "http://rvm.io/binaries/#{node[:platform]}/#{node[:platform_version]}/#{node[:kernel][:machine]}/ruby-#{ruby_version}.tar.bz2"
end

def destination_dir
  new_resource.destination
end

def ruby_bin
  ::File.join(bin_dir, "ruby")
end

def gem_bin
  ::File.join(bin_dir, "gem")
end

def bin_dir
  ::File.join(destination_dir, "bin")
end

def ruby_version
  new_resource.version
end

def rubygems_version
  new_resource.rubygems
end
