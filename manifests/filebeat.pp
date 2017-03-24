# Filebeat
class beats::filebeat (
  $ensure        = present,
  $idle_timeout  = '5s',
  $prospectors   = {},
  $registry_file = '/var/lib/filebeat/registry',
  $spool_size    = 1024,
  $version_v5    = false,
){

  if ($ensure == 'absent'){
    $service_ensure = undef
    $service_enable = undef
  }
  else{
    $service_ensure = $beats::ensure
    $service_enable = $beats::enable
  }

  if ($ensure != 'absent'){
    beats::common::headers {'filebeat':}
    concat::fragment {'filebeat.header':
      target  => '/etc/filebeat/filebeat.yml',
      content => template('beats/filebeat/filebeat.yml.erb'),
      order   => '05',
      notify  => Service['filebeat'],
    }
  }

  case $::osfamily {
    'RedHat': {
      package {'filebeat':
        ensure  => $ensure,
        require => Yumrepo['elastic-beats'],
      }

      exec { 'update package to 5.x':
        command => "yum update filebeat -y",
        unless  => [
          "rpm -qa filebeat |grep '5.[0-9].[0-9]' |grep \"\" -c",
        ],
        require => Package['filebeat'],
      }
    }
    default: {
      include ::apt::update

      package {'filebeat':
        ensure  => $ensure,
        require => Class['apt::update'],
      }
    }
  }

  service { 'filebeat':
    ensure => $service_ensure,
    enable => $service_enable,
  }
  if ($prospectors and $ensure != 'absent'){
    create_resources('::beats::filebeat::prospector', $prospectors )
  }

  if ($ensure != 'absent'){
    Package['filebeat'] -> Concat::Fragment['filebeat.header'] ->
    Beats::Filebeat::Prospector <||> ~> Service['filebeat']
  }
  else{
    Package['filebeat'] ~> Service['filebeat']
  }
}