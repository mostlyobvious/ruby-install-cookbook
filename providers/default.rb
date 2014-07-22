action :create do
  cache_dir            = Chef::Config[:file_cache_path]
  archive_name         = "ruby-#{ruby_version}.tar.bz2"
  ruby_dir             = ::File.join(cache_dir, "ruby-#{ruby_version}")
  download_destination = ::File.join(cache_dir, archive_name)

  remote_file download_destination do
    source download_source
    mode   "0644"
    action :create_if_missing
  end

  execute "Extract ruby archive" do
    command "tar jxvf #{download_destination} -C #{cache_dir}"
    creates ruby_dir
  end

  execute "Copy ruby to destination" do
    command "cp -r #{ruby_dir} #{new_resource.destination}"
    creates new_resource.destination
  end
end

def download_source
  "http://rvm.io/binaries/#{node[:platform]}/#{node[:platform_version]}/#{node[:kernel][:machine]}/ruby-#{ruby_version}.tar.bz2"
end

def ruby_version
  new_resource.version
end
