%w{nodejs git npm monit}.each do |pkg|
  package pkg do
    action :install
  end
end
# This cookbook is too slow... the remote file takes forever.
#include_recipe "nodejs"

include_recipe "nginx"

file "/etc/nginx/sites-available/default" do
  action :delete
end

link "/etc/nginx/sites-enabled/default" do
  action :delete
end

template "/etc/nginx/sites-available/#{node['ten4-nodejs']['app']}" do
  source "nginx.conf.erb"
  action :create
end

link "/etc/nginx/sites-enabled/#{node['ten4-nodejs']['app']}" do 
  to "/etc/nginx/sites-available/#{node['ten4-nodejs']['app']}"
  action :create
end

directory "/root/.ssh" do
  action :create
  recursive true
end

cookbook_file "/root/.ssh/config" do
  source "ssh_config"
  action :create
end

cookbook_file "/root/.ssh/ten4_github_id" do
  action :create
  mode 0600
end

ssh_known_hosts_entry "github.com"

directory File.dirname(node['ten4-nodejs']['application_directory']) do
  action :create
  recursive true
end

git "#{node['ten4-nodejs']['application_directory']}" do
  repository node['ten4-nodejs'][:git_repository]
  action :sync
end

directory "#{node['ten4-nodejs']['application_directory']}/public" do
  action :create
end

execute "npm install" do
  cwd node['ten4-nodejs']['application_directory']
  command "npm install"
end

template "/etc/init.d/#{node['ten4-nodejs']['app']}" do
  source "init.erb"
  action :create
  mode 0755
end

template "/etc/monit/conf.d/#{node['ten4-nodejs']['app']}" do
  source "monit.erb"
  action :create
  mode 0700
end

service "monit" do
  action :start
end
