## Cookbook Name:: deploy-drupal
## Recipe:: download_drupal
##
## download drupal.
version = "#{node['deploy-drupal']['download']['version']}.#{node['deploy-drupal']['download']['minor_version']}"
tmp_dir = Chef::Config[:file_cache_path]
repo_url = "http://ftp.drupal.org/files/projects"

directory "#{tmp_dir}/#{node['deploy-drupal']['project_name']}" do
  recursive true
end

remote_file "#{tmp_dir}/drupal-#{version}.tar.gz" do
  source "#{repo_url}/drupal-#{version}.tar.gz"
  mode 0644
  action "create_if_missing"
  checksum node["deploy-drupal"]["download"]["checksum"]
end

execute "untar-drupal" do
  cwd tmp_dir
  command "tar -xzf drupal-#{version}.tar.gz -C #{node['deploy-drupal']['project_name']} --strip-components=1"
  not_if { File.exists? "#{node['deploy-drupal']['drupal_root']}/index.php" }
end

execute "install-project-from-path" do
  command "cp -Rf '#{tmp_dir}/#{node['deploy-drupal']['project_name']}/.' '#{node['deploy-drupal']['project_root']}'"
  group node['deploy-drupal']['dev_goup']
  creates node['deploy-drupal']['drupal_root'] + "/index.php"
  not_if { File.exists? "#{node['deploy-drupal']['drupal_root']}/index.php" }
  notifies :restart, "service[apache2]"
end
