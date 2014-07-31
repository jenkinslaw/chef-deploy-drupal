## Cookbook Name:: deploy-drupal
## Recipe:: default
##

include_recipe 'deploy-drupal::dependencies'
include_recipe 'deploy-drupal::apc'
include_recipe 'deploy-drupal::download'
include_recipe 'deploy-drupal::install' 
