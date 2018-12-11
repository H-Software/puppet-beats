# == Class: beats
#
# Module to deploy beats
#
# === Parameters
#
#
# === Variables
#
# === Examples
#
#  class { beats:
#  }
#
# === Authors
#
# @poolski (github)
#
# === Copyright
#
# GPLv2
#
class beats (
  $agentname             = $::fqdn ,
  $tags                  = [],
  $version               = 'latest',
  $ensure                = 'running',
  $enable                = true,
  $ignore_outgoing       = true,
  $refresh_topology_freq = '10',
  $topology_expire       = '15',
  $uid                   = undef,
  $gid                   = undef,
  $outputs_deep_merge    = true,
  $outputs_logstash      = {},
  $outputs_elasticsearch = {},
  $outputs_file          = {},
  $http_enabled          = true,
  $pgsql_enabled         = false,
  $mysql_enabled         = false,
  $redis_enabled         = false,
  $manage_geoip          = true,
  $version_v5            = true,
  $manage_repo           = true,
){

  if (any2bool($version_v5) == false){
    fail("Class['beats']: version_v5 is not true: ${version_v5}")
  }

  if $outputs_deep_merge {
    $_outputs_logstash = hiera_hash('beats::outputs_logstash',{})
    $_outputs_elasticsearch = hiera_hash('beats::outputs_elasticsearch',{})
    $_outputs_file = hiera_hash('beats::outputs_file',{})
  }
  else {
    $_outputs_logstash = $outputs_logstash
    $_outputs_elasticsearch = $outputs_elasticsearch
    $_outputs_file = $outputs_file
  }

  case $::osfamily {
    'RedHat': {
      if($manage_repo){
        include ::beats::repo::yum, ::beats::package, ::beats::config
        Class['beats::repo::yum'] -> Class['beats::package'] -> Class['beats::config']
      }
      else{
        include ::beats::package, ::beats::config
        Class['beats::package'] -> Class['beats::config']
      }
    }
    'Debian': {
      if($manage_repo){
        include ::beats::repo::apt, ::beats::package, ::beats::config
        Class['beats::repo::apt'] -> Class['beats::package'] -> Class['beats::config']
      }
      else{
        include ::beats::package, ::beats::config
        Class['beats::package'] -> Class['beats::config']
      }
    }
    default: {
      fail("${::osfamily} not supported yet")
    }
  }
}
