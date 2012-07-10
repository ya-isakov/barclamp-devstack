#
# Cookbook Name:: devstack
# Recipe:: install
#
# Copyright 2011, Dell, Inc.
# Copyright 2012, Dell, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


dst_dir = "/tmp"
inst_dir = node[:devstack][:devstack_path]
tarball_url = "https://github.com/openstack-dev/devstack/tarball/stable/essex.tar.gz"
filename = tarball_url.split('/').last
remote_file tarball_url do
    source tarball_url
    path "#{dst_dir}/#{filename}"
    action :create
end

bash "uninstall_devstack_with_right_path"
    cwd #{inst_dir}
    code <<-EOH
bash ./unstack.sh
cd /
rm -rf #{inst_dir}
rm -rf /opt/stack
EOH
    if { ::File.exists?("#{inst_dir}") }
end

bash "install_devstack_with_right_path" do
    cwd dst_dir
    code <<-EOH
tar xf #{dst_dir}/#{filename}
mv openstack-dev-devstack-* devstack
mkdir -p $(dirname #{inst_dir})
mv devstack $(dirname #{inst_dir})
EOH
    not_if { ::File.exists?("#{inst_dir}") }
end

template "#{node[:devstack][:devstack_path]}/localrc" do
    source "localrc.erb"
    mode 0644
end
